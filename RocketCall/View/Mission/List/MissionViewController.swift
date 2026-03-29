//
//  MissionViewController.swift
//  RocketCall
//
//  Created by 손영빈 on 3/24/26.
//

import UIKit
import RxSwift
import RxCocoa

enum MissionItem: Hashable {
    case activatedMission(ActivatedMissionPayload)
    case customMission(MissionPayload)
}

class MissionViewController: UIViewController {
    
    private let mainView = MissionView()
    private let disposeBag = DisposeBag()
    private let viewModel: MissionViewModel
    private let timerViewModel: TimerViewModel
    // 화면 밖으로 페이로드  넘기기 위해서 프로퍼티 추가
    private let activatedMissionsRelay = BehaviorRelay<[ActivatedMissionPayload]>(value: [])
    
    private var missions: [MissionPayload] = []
    private let initialLoadSubject = PublishSubject<Void>()
    
    private var activatedMissions: [ActivatedMissionPayload] = []
    private let activatedMissionSubject = PublishSubject<MissionPayload>()
    
    private let pauseResumeMissionSubject = PublishSubject<UUID>()
    private let stopMissionSubject = PublishSubject<UUID>()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<MissionSection, MissionItem> = {
        let dataSource = UICollectionViewDiffableDataSource<MissionSection, MissionItem>(collectionView: mainView.collectionView) {[weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { fatalError("Error: self is nil") }
            switch itemIdentifier {
            case .activatedMission(let mission):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivatedMissionCell.id, for: indexPath) as? ActivatedMissionCell else { fatalError("ActivatedMissionCell dequeueReusableCell error") }
                cell.config(mission: mission)
                cell.pauseResumeButtonTapped
                    .map { mission.id }
                    .bind(to: self.pauseResumeMissionSubject)
                    .disposed(by: cell.disposeBag)
                cell.stopButtonTapped
                    .map { mission.id }
                    .bind(to: self.stopMissionSubject)
                    .disposed(by: cell.disposeBag)
                return cell
                
            case .customMission(let mission):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomMissionCell.id, for: indexPath) as? CustomMissionCell else { fatalError("CustomMissionCell dequeueReusableCell error") }
                cell.config(mission: mission)
                cell.startButtonTapped
                    .map { mission }
                    .bind(to: self.activatedMissionSubject )
                    .disposed(by: cell.disposeBag)
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionType = self.dataSource.sectionIdentifier(for: indexPath.section) else { return UICollectionReusableView() }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MissionHeaderView.id, for: indexPath) as? MissionHeaderView else { fatalError("MissionHeaderView dequeueReusableSupplementaryView error")}
            header.config(title: sectionType.title)
            return header
        }
        return dataSource
    }()
    
    let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager, timerViewModel: TimerViewModel) {
        self.coreDataManager = coreDataManager
        self.viewModel = MissionViewModel(coreDataManager: coreDataManager)
        self.timerViewModel = timerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialLoadSubject.onNext(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setDelegate()
        bind()
    }
}

extension MissionViewController {
    private func bind() {
        mainView.titleView.addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let nextVM = CreateMissionViewModel(coreDataManager: self.coreDataManager)
                let nextVC = CreateMissionViewController(
                    viewModel: nextVM,
                    // 미션 정보 클로저 넘김
                    onMissionCreated: { [weak self] mission in
                        // 시작하면 정보 넘기도록
                        self?.activatedMissionSubject.onNext(mission)
                    }
                )
                self.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: disposeBag)
        
        let input = MissionViewModel.Input(initialize: initialLoadSubject.asObservable())
        let output = viewModel.transform(input)
        
        output.missions
            .subscribe(onNext: { [weak self] missions in
                self?.missions = missions
                self?.setSnapshot(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.error
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(error: error)
            })
            .disposed(by: disposeBag)
        
        let timerInput = TimerViewModel.Input(
            activatedMission: activatedMissionSubject.asObservable(),
            pauseResumeButtonTapped: pauseResumeMissionSubject.asObservable(),
            stopButtonTapped: stopMissionSubject.asObservable()
        )
        
        let timerOutput = timerViewModel.transform(timerInput)
        
        timerOutput.activatedMissions
            .subscribe(onNext: { [weak self] (activatedMissions, animated) in
                self?.activatedMissions = activatedMissions
                // 시작된 미션 받아서 저장함(타이머 화면에서 정보 받을 수 있도록)
                self?.activatedMissionsRelay.accept(activatedMissions)
                self?.setSnapshot(animated: animated)
            })
            .disposed(by: disposeBag)
        
        // 새미션 시작시 타이머 화면으로 보내기
        timerOutput.startedMission
            .subscribe(onNext: { [weak self] activatedMission in
                self?.showTimerAnimationViewController(for: activatedMission)
            })
            .disposed(by: disposeBag)

        timerOutput.error
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(error: error)
            })
            .disposed(by: disposeBag)
        
        /*
         // 타이머로 보내기 위해서 결과 띄우는 로직은 삭제했습니다.
        timerOutput.missionResult
            .subscribe(onNext: { [weak self] resultId in
                guard let self else { return }
                let resultVC = MissionResultViewController(coreDataManager: self.coreDataManager, resultId: resultId)
                self.navigationController?.pushViewController(resultVC, animated: true)
            })
            .disposed(by: disposeBag)
         */
    }
}

extension MissionViewController {
    private func setDelegate() {
        mainView.collectionView.delegate = self
        mainView.collectionView.register(ActivatedMissionCell.self, forCellWithReuseIdentifier: ActivatedMissionCell.id)
        mainView.collectionView.register(CustomMissionCell.self, forCellWithReuseIdentifier: CustomMissionCell.id)
        mainView.collectionView.register(MissionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MissionHeaderView.id)
    }
}

extension MissionViewController: UICollectionViewDelegate {
    // 셀 누르면 타이머 화면으로 가도록 함
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .activatedMission(let mission):
            showTimerAnimationViewController(for: mission)
        case .customMission:
            break
        }
    }
}

extension MissionViewController {
    // 타이머 화면 띄우는 코드
    private func showTimerAnimationViewController(for activatedMission: ActivatedMissionPayload) {
        // 해당 하는 id 꺼내서 저장
        let activatedMissionState = activatedMissionsRelay
            .asObservable()
            .compactMap { missions in
                missions.first(where: { $0.id == activatedMission.id })
            }
        let planetImageName = planetImageName(for: activatedMission.id)
        // 해당 id로 결과창 화면 띄움 - 일시정지/정지 같이 처리해줌
        let timerViewController = TimerAnimationViewController(
            activatedMissionState: activatedMissionState,
            planetImageName: planetImageName,
            onPauseResumeRequested: { [weak self] in
                self?.pauseResumeMissionSubject.onNext(activatedMission.id)
            },
            onMissionStopRequested: { [weak self] in
                self?.stopMissionSubject.onNext(activatedMission.id)
            }
        )
        navigationController?.pushViewController(timerViewController, animated: true)
    }
    // 타이머 마다 랜덤하게 행성 띄워주기
    private func planetImageName(for missionId: UUID) -> String {
        let imageNames = TimerAnimationView.availablePlanetImageNames
        // UUID를 -> 문자 -> 숫자변환 -> 합하기 그다음 행성 이미지 수로 나누어서 행성 짝지어주기
        let scalarSum = missionId.uuidString.unicodeScalars.reduce(0) { partialResult, scalar in
            partialResult + Int(scalar.value)
        }
        return imageNames[scalarSum % imageNames.count]
    }
    
    private func setSnapshot(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<MissionSection, MissionItem>()
        snapshot.appendSections(MissionSection.allCases)
        snapshot.appendItems(activatedMissions.map { .activatedMission($0)}, toSection: .activatedMission)
        snapshot.appendItems(missions.map { .customMission($0)}, toSection: .customMission)
        
        if activatedMissions.isEmpty {
            snapshot.deleteSections([.activatedMission])
        }
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension MissionViewController {
    
    private func showErrorAlert(error: CoreDataManager.CoreDataError) {
        let message: String
        switch error {
        case .descriptionLoadFailed:
            message = "데이터 모델을 불러오는 데 실패했습니다."
        case .saveFailed:
            message = "데이터를 저장하는데 실패했습니다."
        case .loadFailed:
            message = "데이터를 불러오는 데 실패했습니다."
        case .empty:
            message = "데이터가 없습니다."
        }
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
