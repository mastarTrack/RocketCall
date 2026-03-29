//
//  TimerAnimationViewController.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TimerAnimationViewController: UIViewController {
    private let timerAnimationView = TimerAnimationView()
    private let timerView = TimerAnimationBottomView()
    private let viewModel = TimerAnimationViewModel()
    private let disposeBag = DisposeBag()
    private let activatedMissionState: Observable<ActivatedMissionPayload> // 이걸 기준으로 화면 표시
    // MissionList로직 같이 쓰도록 버튼 눌릴시 밖으로 넘김
    private let onPauseResumeRequested: (() -> Void)?
    private let onMissionStopRequested: (() -> Void)?
    
    init(
        activatedMissionState: Observable<ActivatedMissionPayload>,
        onPauseResumeRequested: (() -> Void)? = nil,
        onMissionStopRequested: (() -> Void)? = nil
    ) {
        self.activatedMissionState = activatedMissionState
        self.onPauseResumeRequested = onPauseResumeRequested
        self.onMissionStopRequested = onMissionStopRequested
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLayout()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .background
        view.addSubview(timerAnimationView)
        view.addSubview(timerView)
    }
    
    // 상단은 애니메이션 하단은 타이머
    private func setupLayout() {
        timerAnimationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(2.0 / 3.0)
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalTo(timerAnimationView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        let input = TimerAnimationViewModel.Input(
            activatedMissionState: activatedMissionState,
            stopButtonTapped: timerView.stopButton.rx.tap.asObservable(),
            missionStopButtonTapped: timerView.missionStopButton.rx.tap.asObservable(),
            backButtonTapped: timerView.backButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        // 하단 뷰 갱신
        Observable
            .combineLatest(output.missionTitleText, output.timerText, output.cycleText)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] values in
                let (missionTitle, timerText, cycleText) = values
                self?.timerView.configure(
                    missionTitle: missionTitle,
                    timerText: timerText,
                    cycleText: cycleText
                )
            })
            .disposed(by: disposeBag)
        
        // 애니메이션 갱신
        Observable
            .combineLatest(output.remainingTime, output.totalDuration)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] values in
                let (remainingTime, totalDuration) = values
                self?.timerAnimationView.updatePlanetProgress(
                    remainingTime: remainingTime,
                    totalDuration: totalDuration
                )
            })
            .disposed(by: disposeBag)
        
        output.stopButtonImage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.timerView.stopButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        //눌린 이벤트만 전달(ActivatedMissionCell 해당로직이랑 밖에서 같이 처리함)
        output.pauseResumeRequested
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.onPauseResumeRequested?()
            })
            .disposed(by: disposeBag)

        output.routeStopMission
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.onMissionStopRequested?()
            })
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼 눌렸을 시 missionViewController 띄움
        output.routeBack
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.popToMissionViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func popToMissionViewController() {
        guard let navigationController else { return }
        
        if let missionViewController = navigationController.viewControllers.last(where: { $0 is MissionViewController }) {
            navigationController.popToViewController(missionViewController, animated: true)
            return
        }
        navigationController.popViewController(animated: true)
    }
}
