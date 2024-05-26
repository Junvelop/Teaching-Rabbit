import SwiftUI

struct ContentView: View {
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var buttonTapCount: Int = 0
    @State private var showAlert: Bool = false
    private let texts = [
        " ",
        "안녕 나는 토끼야  너에게 오픈소스 라이센스를 알려주기 위해 왔어!",
        "먼저 필요성부터 알아볼까?",
        "요즘 AI의 발전이 빠르게 진행되고 있는 것은 미디어를 통해서 다들 보았지?",
        "AI를 학습시키는 데 필요한 데이터를 무단으로 가져오면 법적으로 처벌 가능성이 있어.",
        "실제로 open ai나 메타도 데이터를 무단으로 가져와 저작권법 위반으로 소송을 걸린 사례가 있어.",
        "법적 문제를 피하고 소프트웨어의 생태계를 유지하기 위해서는 오픈소스에 대한 라이센스 준수가 필수적이야",
        "다음 코스로 넘어가볼까?"
    ]
    private let displayInterval = 0.1
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("rabbit")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 200)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: 150, height: 65)
                .offset(x: 150, y: 10)
            
            VStack(alignment: .leading) {
                Text(displayedText)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .frame(maxWidth: 130)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .offset(x: 150, y: 20)
            
            Button(action: buttonAction) {
                Text("버튼")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            .frame(width: 60, height: 20)
            .offset(x: 250, y: 165)
            
            if displayedText.contains("실제로 open ai나 메타도 데이터를 무단으로 가져와 저작권법 위반으로 소송을 걸린 사례가 있어.") {
                Image("opensource")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .offset(x: 120, y: 100)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("알림"),
                message: Text("다음 단계로 넘어가세요"),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    
    private func buttonAction() {
        currentIndex = 0
        displayedText = ""
        buttonTapCount += 1
        
        if buttonTapCount >= texts.count {
            showAlert = true
        } else {
            let index = buttonTapCount % texts.count
            startTyping(text: texts[index])
        }
    }
    
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

