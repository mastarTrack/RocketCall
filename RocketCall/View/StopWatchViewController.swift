//
//  StopWatchViewController.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/24/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

/// StopWatch ViewController
class StopWatchViewController: UIViewController {
    
    //MARK: - ViewModel
    private let vm = StopWatchViewModel()
    
    //MARK: - Properties
    private var disposeBag = DisposeBag()
    
    //MARK: - Components
    private let titleView = TitleView(
        title: "자유 항행 모드",
        subTitle: "스톱워치 기능으로 원하는 시간까지 카운트하세요.",
        hasButton: false
    )
    
    /// StopWatch 상단 타임 뷰
    private let stopWatchHeaderView = StopWatchHeaderView()
    
    /// StopWatch 하단 레코드 뷰  
    private let stopWatchRecordView = StopWatchRecordView()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        //description = "스톱워치 기능으로 원하는 시간까지 카운트하세요."
        view.backgroundColor = .background
        configureUI()
        bind()
    }
}

//MARK: - Binding
extension StopWatchViewController {
    func bind() {
        // View Action Setting
        // 시작/일시정지 버튼 탭 이벤트 설정
        let startPause = stopWatchHeaderView.startButton.rx.tap
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                // UI 상태를 직접 변경
                self.stopWatchHeaderView.startButton.isSelected.toggle()
                if self.stopWatchHeaderView.startButton.isSelected {
                    self.stopWatchHeaderView.recordButton.isEnabled = true
                } else {
                    self.stopWatchHeaderView.recordButton.isEnabled = false
                }
            })
            .map { [weak self] _ -> StopWatchViewModel.State in
                guard let self = self else { return .pause }
                return self.stopWatchHeaderView.startButton.isSelected ? .run : .pause
            }
            .share()
        
        // 리셋 버튼 탭 이벤트 설정
        let reset = stopWatchHeaderView.resetButton.rx.tap
            .do(onNext: {
                self.stopWatchHeaderView.startButton.isSelected = false
                self.stopWatchHeaderView.recordButton.isEnabled = false
            })
            .map { _ -> StopWatchViewModel.State in
                return  .reset
            }
        
        // 레코드 버튼 탭 이벤트 설정
        let record = stopWatchHeaderView.recordButton.rx.tap
            .map { return }
        
        // ViewModel 액션 전달 Input 세팅
        let input = StopWatchViewModel.Input(
            stopwatchAction: Observable.merge(startPause,reset),
            record: record
        )
        
        // View Action -> ViewModel
        let output = vm.transform(input)
        
        
        // ViewModel -> View Binding
        // 스탑워치 메인 시간 텍스트 바인딩
        output.mainTimer
            .bind(to: stopWatchHeaderView.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 레코드 바인딩
        output.record
            .bind(onNext: { [weak self] datas in
                guard let self else { return }
                self.stopWatchRecordView.applySnapshot(with: datas)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Configure UI
extension StopWatchViewController {
    private func configureUI() {
        let mainStack = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 32
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        mainStack.addArrangedSubview(stopWatchHeaderView)
        mainStack.addArrangedSubview(stopWatchRecordView)
        
        view.addSubview(titleView)
        view.addSubview(mainStack)
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        mainStack.snp.makeConstraints { ms in
            ms.top.equalTo(titleView.snp.bottom)
            ms.leading.equalToSuperview().offset(20)
            ms.trailing.bottom.equalToSuperview().inset(20)
        }

        stopWatchHeaderView.snp.makeConstraints {
            $0.height.equalTo(430)
        }
    }

}

@available(iOS 17.0, *)
#Preview {
    StopWatchViewController()
}
