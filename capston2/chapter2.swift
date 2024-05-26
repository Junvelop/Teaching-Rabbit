import SwiftUI

struct ContentView2: View {
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var buttonTapCount: Int = 0
    @State private var showAlert: Bool = false
    @State private var showQuiz: Bool = false
    @State private var showChat: Bool = false
    @State private var inputMessages: [String] = []
    @State private var chatMessages: [ChatMessage] = [ChatMessage(role: "system", content: "You are a helpful assistant.")]

    let texts = [
        "안녕하세요, 여러분. 오늘은 오픈소스 라이센스에 대해 더 깊이 알아보도록 하겠습니다.",
        "오픈소스 소프트웨어는 현대 소프트웨어 개발의 중요한 부분이며, 우리가 많이 사용하는 리눅스 운영 체제나 파이썬 프로그래밍 언어 등이 이에 해당합니다.",
        "이러한 소프트웨어는 소스 코드가 공개되어 있어 누구나 자유롭게 사용, 수정, 배포할 수 있는 특징을 가지고 있습니다.",
        "그렇다면, 이 오픈소스 소프트웨어를 사용할 때 라이센스가 왜 중요한지 알아보겠습니다.",
        "라이센스는 소프트웨어를 사용하는 규정을 정의하는데, 이를 준수하지 않으면 법적 문제가 발생할 수 있습니다.",
        "또한, 각각의 라이센스는 사용 가능한 방법과 제약 사항이 다르므로, 이를 잘 이해하고 선택해야 합니다.",
        "예를 들어, MIT 라이센스는 수정한 소스 코드를 공개하지 않아도 되는 자유로운 라이센스입니다.",
        "반면에 GPL은 수정한 소스 코드를 공개해야 하는 '강제 공개' 조항이 있습니다.",
        "Apache 라이센스는 상업적 이용이 가능하며, 수정한 소스 코드를 공개하지 않고도 재배포할 수 있는 특징을 가지고 있습니다.",
        "라이센스를 선택할 때에는 프로젝트의 목적과 필요에 맞게 고려해야 합니다. 그리고 선택한 라이센스를 관리하고 준수하는 것이 매우 중요합니다.",
        "라이센스를 준수하지 않으면 소프트웨어 사용자나 개발자들 간에 분쟁이 발생할 수 있습니다.",
        "예를 들어, 회사 A가 오픈소스 소프트웨어를 사용하고 있지만, 라이센스를 제대로 이해하지 않고 수정한 코드를 공개하지 않았다고 가정해 봅시다.",
        "이에 소프트웨어를 개발한 개발자 B가 회사 A를 상대로 소송을 제기할 수 있습니다. 이는 회사 A에 큰 손해를 입힐 뿐만 아니라 이미 출시된 제품에도 영향을 미칠 수 있습니다.",
        "오픈소스는 저작권, 특허권, 상표권, 영업비밀로 법적보호가 됩니다. ",
        
        "이러한 사례를 통해 보면, 라이센스를 관리하고 준수하는 것이 얼마나 중요한지 알 수 있습니다.",
        "오픈소스 소프트웨어를 사용할 때는 항상 해당 소프트웨어의 라이센스를 주의 깊게 살펴보고, 그에 따라야 합니다.",
        "오늘 배운 내용을 바탕으로, 여러분도 오픈소스 라이센스에 대해 더 깊이 이해할 수 있을 거라고 믿습니다.",
        "함께 오픈소스 생태계에 기여하여 더 나은 소프트웨어 문화를 만들어 나가는데 동참해봅시다."
    ]

    private let displayInterval = 0.05

    var body: some View {
        ZStack(alignment: .topLeading) {
            BackgroundImageView()
            
            TypingTextView(displayedText: $displayedText)
            
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
            
            Button(action: {
                showChat = true
            }) {
                Text("챗")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            .frame(width: 60, height: 20)
            .offset(x: 20, y: 165)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("알림"),
                message: Text("다음 단계로 넘어가세요"),
                // dismissButton: .default(Text("확인"))
                dismissButton: .default(Text("확인")) {
                    // 알림 확인 버튼을 누르면 퀴즈 뷰를 표시합니다.
                    showQuiz = true
                }
            )
        }
        .sheet(isPresented: $showQuiz) {
            QuizView(showQuiz: $showQuiz)
        }
        .sheet(isPresented: $showChat) {
            ChatView(chatMessages: $chatMessages)
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

struct BackgroundImageView: View {
    var body: some View {
        Image("rabbit")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 200)
            .clipped()
    }
}

struct TypingTextView: View {
    @Binding var displayedText: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white)
            .frame(width: 150, height: 65)
            .offset(x: 150, y: 10)
            .opacity(0.8)
        
        VStack(alignment: .leading) {
            Text(displayedText)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineLimit(10)
                .frame(maxWidth: 130)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background(Color.white)
                .cornerRadius(10)
                .opacity(0.8)
        }
        .offset(x: 150, y: 20)
    }
}

enum QuestionType {
    case multipleChoice
    case trueFalse
}

struct QuizView: View {
    @Binding var showQuiz: Bool
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedAnswer: Int?
    @State private var showResult: Bool = false
    @State private var isCorrect: Bool = false
    
    private struct QuizQuestion {
        let question: String
        let answers: [String]
        let correctAnswer: Int
        let type: QuestionType
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(question: "오픈소스는 무엇으로 보호되나요?", answers: ["저작권", "특허권", "상표권", "영업비밀", "모두 해당"], correctAnswer: 4, type: .multipleChoice),
        QuizQuestion(question: "MIT 라이센스의 특징은 무엇입니까?", answers: ["수정한 소스 코드를 공개할 필요 없음", "강제 공개 조항이 있음", "상업적 이용 불가능"], correctAnswer: 0, type: .multipleChoice),
        QuizQuestion(question: "GPL 라이센스의 특징은 무엇입니까?", answers: ["수정한 소스 코드를 공개할 필요 없음", "강제 공개 조항이 있음", "수정이 허용되지 않음"], correctAnswer: 1, type: .multipleChoice),
        QuizQuestion(question: "오픈소스 소프트웨어를 사용할 때 라이센스의 중요성에 대해 참거짓 문제입니다.", answers: ["참", "거짓"], correctAnswer: 0, type: .trueFalse),
        QuizQuestion(question: "Apache 라이센스는 수정한 소스 코드를 공개하지 않고도 재배포할 수 있는 특징을 가지고 있습니까?", answers: ["참", "거짓"], correctAnswer: 0, type: .trueFalse),
        QuizQuestion(question: "라이센스 선택 시 고려해야 하는 요소는 무엇인가요?", answers: ["각 라이센스의 허용 범위", "프로젝트 목적과 필요에 맞는 라이센스 선택", "라이센스의 제약사항", "모두"], correctAnswer: 3, type: .multipleChoice),
        QuizQuestion(question: "라이센스를 준수하지 않을 경우 발생할 수 있는 문제는 무엇인가요?", answers: ["저작권 침해", "소송 가능성", "프로젝트 중단", "모두"], correctAnswer: 3, type: .multipleChoice)
    ]
    
    var body: some View {
        VStack {
            if currentQuestionIndex < questions.count {
                let currentQuestion = questions[currentQuestionIndex]
                Text(currentQuestion.question)
                    .font(.title)
                    .padding()
                
                ForEach(0..<currentQuestion.answers.count, id: \.self) { index in
                    Button(action: {
                        selectedAnswer = index
                        showResult = true
                        isCorrect = index == currentQuestion.correctAnswer
                        if isCorrect {
                            nextQuestion()
                        }
                    }) {
                        Text(currentQuestion.answers[index])
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                    }
                    .disabled(showResult)
                }
                
                if showResult {
                    Text(isCorrect ? "정답입니다! 다음 문제로 넘어갑니다." : "틀렸습니다. 다시 시도하세요.")
                        .foregroundColor(isCorrect ? .green : .red)
                        .padding()
                }
            } else {
                Text("퀴즈가 종료되었습니다.")
                    .padding()
                
                Button(action: {
                    showQuiz = false
                }) {
                    Text("닫기")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
        }
        .padding()
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                currentQuestionIndex += 1
                showResult = false
                selectedAnswer = nil
            }
        } else {
            showQuiz = false
        }
    }
}


struct ChatMessage: Identifiable, Codable {
    var id = UUID()
    let role: String
    let content: String
}

struct ChatView: View {
    @Binding var chatMessages: [ChatMessage]
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            List(chatMessages) { message in
                Text("\(message.role == "user" ? "나: " : "챗GPT: ")\(message.content)")
            }
            
            HStack {
                TextField("메시지를 입력하세요", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: sendMessage) {
                    Text("전송")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        let userMessage = ChatMessage(role: "user", content: inputText)
        chatMessages.append(userMessage)
        
        // 사용자가 입력한 메시지와 이전 대화 메시지를 함께 전송
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            sendToOpenAI(messages: chatMessages) { response in
                DispatchQueue.main.async {
                    chatMessages.append(ChatMessage(role: "assistant", content: response))
                }
            }
        }
        
        inputText = ""
    }
    
    private func sendToOpenAI(messages: [ChatMessage], completion: @escaping (String) -> Void) {
       
        let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""

        let modelId = "gpt-3.5-turbo"
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion("API 요청에 실패했습니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let messagePayload = messages.map { ["role": $0.role, "content": $0.content] }
        
        let requestBody: [String: Any] = [
            "model": modelId,
            "max_tokens": 2200,
            "temperature": 0.7,
            "messages": messagePayload
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion("요청 본문을 만들 수 없습니다.")
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("네트워크 오류: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion("서버 응답이 올바르지 않습니다.")
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion("데이터를 받지 못했습니다.")
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                    let responseText = result.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) ?? "응답을 해석할 수 없습니다."
                    completion(responseText)
                } catch {
                    completion("응답을 해석할 수 없습니다: \(error.localizedDescription)")
                }
                
            default:
                completion("서버 오류: \(httpResponse.statusCode)")
            }
        }.resume()
    }
    
    struct OpenAIResponse: Codable {
        let choices: [Choice]
        
        struct Choice: Codable {
            let message: Message
        }
        
        struct Message: Codable {
            let role: String
            let content: String
        }
    }
}

