
let NTP_DATE = "ntp_date"
let NTP_UPTIME = "ntp_uptime"
let LAST_REBOOT = "last_reboot"

import Foundation

// isTimeValid returns true:
// 1. not rebooted
// 2. (currentOfflineDateTime - syncedDateTime) <= 48 hours

class CheckinHelper {

    static var syncedDate: TimeInterval? {
        set { UserDefaults.standard.set(newValue, forKey: NTP_DATE) }
        get { return UserDefaults.standard.object(forKey: NTP_DATE) as? TimeInterval }
    }
    
    static var syncedUptime: TimeInterval? {
        set { UserDefaults.standard.set(newValue, forKey: NTP_UPTIME) }
        get { return UserDefaults.standard.object(forKey: NTP_UPTIME) as? TimeInterval }
    }
    
    static var lastReboot: TimeInterval? {
        set { UserDefaults.standard.set(newValue, forKey: LAST_REBOOT) }
        get { return UserDefaults.standard.object(forKey: LAST_REBOOT) as? TimeInterval }
    }
    
    static let shared = CheckinHelper()
    private init() {}
    
    
    func getUptime() -> TimeInterval {
        return TimeInterval(self.uptime())
    }
    
    func uptime() -> time_t {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout<timeval>.stride

        var now = time_t()
        var uptime: time_t = -1

        time(&now)
        if (sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0) {
            uptime = now - boottime.tv_sec
        }
        return uptime
    }
    
    func getCurrentOfflineTime() -> TimeInterval? {
        if let syncDate = CheckinHelper.syncedDate, let syncUptime = CheckinHelper.syncedUptime {
            let newUptime = getUptime()
            
            let difference = newUptime - syncUptime
            let currentDateTime = syncDate + difference
            
            return currentDateTime
        }
        return nil
    }
    
    func uptimeAllowedPeriod() -> Bool {          //Hours difference should be less than 48 hours
        if let syncDateTime = CheckinHelper.syncedDate, let currentDateTime = getCurrentOfflineTime() {
            let syncDate = Date(timeIntervalSince1970: syncDateTime)
            let currentDate = Date(timeIntervalSince1970: currentDateTime)
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: syncDate, to: currentDate)
            return components.hour ?? 999 < 72
            
        }
        return false
    }
    
    //MARK: 
    func isRebooted() -> Bool {
        if let lastRebooted = CheckinHelper.lastReboot {
            let now = Date().timeIntervalSince1970
            let uptime = getUptime()
            let newLastRebooted = now - uptime
            
            if (newLastRebooted - lastRebooted) >= 60 {
                CheckinHelper.lastReboot = newLastRebooted
                return true
            } else {
                return false
            }
        } else {
            let now = Date().timeIntervalSince1970
            let uptime = getUptime()
            let newLastRebooted = now - uptime
            CheckinHelper.lastReboot = newLastRebooted
            
            return false
        }
    }
    
    func isTimeValid() -> Bool {
        if !isRebooted() {
            return true
        } else {
            return false
        }
    }

    func deviceTime() -> String? {
        if let interval = getCurrentOfflineTime() {
            let date = Date(timeIntervalSince1970: interval)
                let formatter = DateFormatter();
                formatter.timeZone = TimeZone.current;
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
                let str = formatter.string(from: date);
                var dateString = str
                if str.hasSuffix("Z") {
                    dateString = str.replacingOccurrences(of: "Z", with: "+00:00") 
                }
            return dateString
        }
        else {
            return nil
        }
    }
    
}
