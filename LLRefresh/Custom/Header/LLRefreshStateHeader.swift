//
//  LLRefreshStateHeader.swift
//  LLRefrsh
//
//  Created by 李兴乐 on 2016/12/2.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

class LLRefreshStateHeader: LLRefreshHeader {
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.autoresizingMask = .flexibleWidth
        label.backgroundColor = UIColor.clear
        self.addSubview(label)
        return label
    }()
    lazy var lastUpdatedTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.autoresizingMask = .flexibleWidth
        label.backgroundColor = UIColor.clear
        self.addSubview(label)
        return label
    }()
    
    fileprivate var stateTitles:[Int:String] = [:]
    
    var lastUpdatedTimeText:((Date?)->())?
    var labelLeftInset:CGFloat = 0
    
    //MARK: -  集成父类方法
    override func placeSubViews() {
        super.placeSubViews()
        guard !stateLabel.isHidden else {
            return
        }
        
        if lastUpdatedTimeLabel.isHidden {
            stateLabel.frame = bounds
        }else {
            let stateLableH = ll_h*0.5
            if stateLabel.constraints.count == 0 {
                stateLabel.ll_x = 0
                stateLabel.ll_y = 0
                stateLabel.ll_w = ll_w
                stateLabel.ll_h = stateLableH
            }
           
            if lastUpdatedTimeLabel.constraints.count == 0  {
                lastUpdatedTimeLabel.ll_x = 0
                lastUpdatedTimeLabel.ll_y = stateLableH
                lastUpdatedTimeLabel.ll_w = ll_w
                lastUpdatedTimeLabel.ll_h = ll_h - lastUpdatedTimeLabel.ll_y
            }
        }
 
    }
    
    override func prepare() {
        super.prepare()
        // 初始化间距
        labelLeftInset = LLConstant.RefreshLabelLeftInset
        
        setTitle("下拉可以刷新", state: .normal)
        setTitle("松开立即刷新", state: .pulling)
        setTitle("正在刷新数据中", state: .refreshing)
        
        setLastUpdateTimeLable()
    }
    override func setState(_ state: LLRefreshState) {
        super.setState(state)
        stateLabel.text = stateTitles[refreshState.rawValue]
        setLastUpdateTimeLable()
    }
    //MARK: - Private
    func setLastUpdateTimeLable() {
        guard !lastUpdatedTimeLabel.isHidden else {
            return
        }
        //外部自定义
        if let lastUpdatedTimeText = lastUpdatedTimeText {
            lastUpdatedTimeText(lastUpdateTime as Date?)
            return
        }
        if let lastUpdateTime = lastUpdateTime {
            var calendar:Calendar?

            if NSCalendar.responds(to: #selector(NSCalendar.init(identifier:))) {
                 calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) as Calendar?
            }
            calendar = Calendar.current
//            let calendarUnit =
            
            let cmp1 = (calendar as NSCalendar?)?.components([NSCalendar.Unit.year, NSCalendar.Unit.month , NSCalendar.Unit.day ,NSCalendar.Unit.hour ,NSCalendar.Unit.minute], from:lastUpdateTime as Date)
            let cmp2 = (calendar as NSCalendar?)?.components([NSCalendar.Unit.year, NSCalendar.Unit.month , NSCalendar.Unit.day ,NSCalendar.Unit.hour ,NSCalendar.Unit.minute], from: Date())
            
            
            //格式化
            let dateForamt = DateFormatter()
            var isToday = false
            if cmp1?.day == cmp2?.day {  //today
                dateForamt.dateFormat = " HH:mm"
                isToday = true
            }else if cmp1?.year == cmp2?.year {  //today
                dateForamt.dateFormat = "MM-dd HH:mm"
            }else if cmp1?.year == cmp2?.year {  //today
                dateForamt.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let time = dateForamt.string(from: lastUpdateTime as Date)
            
            let str = isToday ? "今天" : ""
            
            lastUpdatedTimeLabel.text = "最后更新：\(str)\(time)"
            
            
        }else {     //第一次刷新
            lastUpdatedTimeLabel.text = "最后更新：无记录"
        }
        
        
    }
    
    //MARK: - Public 
    func setTitle(_ title:String?, state:LLRefreshState)  {
        if let title = title {
            stateTitles[state.rawValue] = title
            stateLabel.text = stateTitles[refreshState.rawValue]
        }
    }
    
   

}