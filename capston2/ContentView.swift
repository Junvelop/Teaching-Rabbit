import SwiftUI

struct ContentView: View {
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var buttonTapCount: Int = 0 // 버튼이 눌린 횟수를 나타내는 상태 변수 추가
    private let texts = [
        " ",
        "안녕 나는 토끼야  너에게 오픈소스를 알려주기 위해 왔어!",
        "먼저 필요성부터 알아볼까?",
        "요즘 AI의 발전이 빠르게 진행되고 있는 것은 미디어를 통해서 다들 보았지?",
        "AI를 학습시키는 데 필요한 데이터를 무단으로 가져오면 법적으로 처벌 가능성이 있어.",
        "실제로 open ai나 메타도 데이터를 무단으로 가져와 저작권법 위반으로 소송을 걸린 사례가 있어."
    ]
    private let displayInterval = 0.1 // 각 글자가 표시되는 간격 (초)
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("rabbit")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 200) // 이미지 크기 조정
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: 150, height: 65)
                .offset(x: 150, y: 10) // 말풍선 위치 조정
            
            VStack(alignment: .leading) {
                Text(displayedText)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5) // 텍스트의 최대 줄 수 지정
                    .frame(maxWidth: 130)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .offset(x: 150, y: 20) // 텍스트 위치 조정
            
            // 버튼 추가
            Button(action: {
                // 버튼을 눌렀을 때 실행될 액션
                currentIndex = 0 // 인덱스 초기화
                displayedText = "" // 텍스트 초기화
                buttonTapCount += 1 // 버튼 탭 횟수 증가
                let index = buttonTapCount % texts.count
                startTyping(text: texts[index])
            }) {
                Text("버튼") // 버튼에 표시될 텍스트
                    .padding() // 버튼 내부 패딩 추가
                    .background(Color.blue) // 배경색 설정
                    .foregroundColor(.white) // 텍스트 색상 설정
                    .cornerRadius(10) // 버튼 모서리를 둥글게 만듦
                    .padding() // 바깥쪽 패딩 추가
            }
            .frame(width: 60, height: 20)
            .offset(x: 250, y: 165) // 버튼 위치 조정
            
            // 이미지를 표시하는 조건 추가
            if displayedText.contains("실제로 open ai나 메타도 데이터를 무단으로 가져와 저작권법 위반으로 소송을 걸린 사례가 있어.") {
                Image("opensource")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .offset(x: 120, y: 100)
            }
        }
    }
    
    // 타이핑 시작하는 함수
    private func startTyping(text: String) {
        Timer.scheduledTimer(withTimeInterval: displayInterval, repeats: true) { timer in
            guard currentIndex < text.count else {
                timer.invalidate()
                return
            }
            displayedText += String(text[text.index(text.startIndex, offsetBy: currentIndex)])
            currentIndex += 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
            ContentView()
        
    }
}

