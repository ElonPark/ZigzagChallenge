import Foundation

class AlterDateFormat {
    func alterDateFormat(time: String, after seconds: Int) -> String {
        let inputTimeArray = time.components(separatedBy: " ")
        assert(inputTimeArray.count == 2, "input data is wrong")
        
        let ampm = inputTimeArray[0]
        let times = inputTimeArray[1].components(separatedBy: ":").compactMap { Int($0) }
        assert(times.count == 3, "input data is wrong")
        
        var hh = times[0]
        let mm = times[1]
        let ss = times[2]
        
        if ampm == "PM" {
            hh += 12
        } else if ampm == "AM" && hh == 12 {
            hh = 0
        }
        
        let totalSeconds: Int = (hh * 3600 + mm * 60 + ss) + seconds
        
        var timeArray: [Int] = []
        
        let hours = (totalSeconds % 86400) / 3600
        let remainder = totalSeconds % 3600
        let minutes = remainder / 60
        let seconds = remainder % 60
        
        timeArray.append(hours == 24 ? 0 : hours)
        timeArray.append(minutes)
        timeArray.append(seconds)
        
        return timeArray
            .map { $0 < 10 ? "0\($0)" : "\($0)" }
            .joined(separator: ":")
    }
}

class AlterDateFormatTestCase {
    
    let dateFormatter = AlterDateFormat()
    
    func testAMTime() {
        // given
        let am1 = (time: "AM 12:10:00", delay: 0)
        let am2 = (time: "AM 11:59:30", delay: 0)
        let am3 = (time: "AM 05:24:03", delay: 0)
        
        // when
        let am1WithFomart = dateFormatter.alterDateFormat(time: am1.time, after: 0)
        let am2WithFomart = dateFormatter.alterDateFormat(time: am2.time, after: 0)
        let am3WithFomart = dateFormatter.alterDateFormat(time: am3.time, after: 0)
        
        // Then
        assert(am1WithFomart == "00:10:00", "AM date format is fail \(am1WithFomart) != 00:10:00")
        assert(am2WithFomart == "11:59:30", "AM date format is fail \(am2WithFomart) != 11:59:30")
        assert(am3WithFomart == "05:24:03", "AM date format is fail \(am3WithFomart) != 05:24:03")
    }
    
    func testAMTimeWithSecond() {
        // given
        let am1 = (time: "AM 12:10:00", delay: 40)
        let am2 = (time: "AM 11:59:30", delay: 30)
        let am3 = (time: "AM 05:24:03", delay: 102392)
        let am4 = (time: "AM 01:24:03", delay: 200000)
        
        // when
        let am1WithFomart = dateFormatter.alterDateFormat(time: am1.time, after: am1.delay)
        let am2WithFomart = dateFormatter.alterDateFormat(time: am2.time, after: am2.delay)
        let am3WithFomart = dateFormatter.alterDateFormat(time: am3.time, after: am3.delay)
        let am4WithFomart = dateFormatter.alterDateFormat(time: am4.time, after: am4.delay)
        
        // Then
        assert(am1WithFomart == "00:10:40", "AM with \(am1.delay) second after is fail \(am1WithFomart) != 00:10:40")
        assert(am2WithFomart == "12:00:00", "AM with \(am2.delay) second after is fail \(am2WithFomart) != 12:00:00")
        assert(am3WithFomart == "09:50:35", "AM with \(am3.delay) second after is fail \(am3WithFomart) != 09:50:35")
        assert(am4WithFomart == "08:57:23", "AM with \(am4.delay) second after is fail \(am4WithFomart) != 08:57:23")
    }
    
    func testPMTime() {
        // given
        let pm1 = (time: "PM 01:00:00", delay: 0)
        let pm2 = (time: "PM 11:59:59", delay: 0)
        
        // when
        let pm1WithFomart = dateFormatter.alterDateFormat(time: pm1.time, after: pm1.delay)
        let pm2WithFomart = dateFormatter.alterDateFormat(time: pm2.time, after: pm2.delay)
        
        // Then
        assert(pm1WithFomart == "13:00:00", "PM date format is fail \(pm1WithFomart) != 13:00:00")
        assert(pm2WithFomart == "23:59:59", "PM date formatis fail \(pm2WithFomart) != 23:59:59")
    }
    
    func testPMTimeWithSecond() {
        // given
        let pm1 = (time: "PM 01:00:00", delay: 10)
        let pm2 = (time: "PM 11:59:59", delay: 1)
        let pm3 = (time: "PM 05:24:03", delay: 102392)
        let pm4 = (time: "PM 01:24:03", delay: 200000)
        
        // when
        let pm1WithFomart = dateFormatter.alterDateFormat(time: pm1.time, after: pm1.delay)
        let pm2WithFomart = dateFormatter.alterDateFormat(time: pm2.time, after: pm2.delay)
        let pm3WithFomart = dateFormatter.alterDateFormat(time: pm3.time, after: pm3.delay)
        let pm4WithFomart = dateFormatter.alterDateFormat(time: pm4.time, after: pm4.delay)
        
        // Then
        assert(pm1WithFomart == "13:00:10", "PM with \(pm1.delay) second after is fail \(pm1WithFomart) != 13:00:10")
        assert(pm2WithFomart == "00:00:00", "PM with \(pm2.delay) second after is fail \(pm2WithFomart) != 00:00:00")
        assert(pm3WithFomart == "21:50:35", "PM with \(pm3.delay) second after is fail \(pm3WithFomart) != 21:50:35")
        assert(pm4WithFomart == "20:57:23", "PM with \(pm4.delay) second after is fail \(pm4WithFomart) != 20:57:23")
    }
    
    func run() {
        testAMTime()
        testPMTime()
        testAMTimeWithSecond()
        testPMTimeWithSecond()
        print("테스트 완료!")
    }
}

AlterDateFormatTestCase().run()
