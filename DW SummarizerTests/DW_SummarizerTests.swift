//
//  DW_SummarizerTests.swift
//  DW SummarizerTests
//
//  Created by Andreas Giefer on 23.02.24.
//

import XCTest
import SelmaKit

final class DW_SummarizerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPriberamSummarizer() async {
        
        // summarize
        let summerizer = PriberamSummerizer()
        
        let incomingText = "Thomas Müller and Rudi Völler help Germany rediscover fun factor.\r\n\r\nRudi Völler\'s Germany beat France, with a performance national team fans have longed to see. Now the question is: who will be the coach to take Germany forward?\r\n\r\nThe sight of Rudi Völler on the touchline felt like a throwback to the early 2000s when German football was stumbling its way forward and World Cup glory was something Germany\'s women knew much more about.\r\n\r\nTwo decades on, Völler\'s hair is a little whiter, and the squad\'s average age is a little young. Still, the former Germany striker once again finds himself at the center of a defining moment in German football history.\r\n\r\nFor a side facing a fourth straight defeat — something Germany have never experienced since that first World Cup win in 1954 — the 2-1 win against France was very welcomed, but it was the manner of the performance that mattered more. \r\n\r\nPerhaps inevitably, Rudi Völler made sure his Germany side delivered the kind of committed performance that has been absent in recent months. To the delight of the home crowd, every tackle won, corner prevented and shot blocked was celebrated by Germany\'s players with high fives and chest bumps. Most fittingly, Thomas Müller scored on his 122 appearance, his 45th for Germany.\r\n\r\n It would be sensationalist to say that after one night in Dortmund under Völler, Hannes Wolf and Sandro Wagner, Germany had finally turned the corner. But a day after Germany captain Ilkay Gündogan said he and other teammates felt they had \"let Hansi [Flick] down\" because they could not translate his drive into good performances, Germany did look like they were having fun playing football again.\r\n\r\n\"The fans were with us in Wolfsburg too, and they\'d have reveled in a result and game like tonight, but here in Dortmund, it\'s another level, and this is how it should be,\" said Thomas Müller as he soaked in the post-match atmosphere while talking to ARD.\r\n\r\n\"We executed things well on the pitch. We were fluid and rewarded ourselves at the right time. When you do that and win, it\'s a lot of fun.\" \r\n\r\nThe last time that looked the case was Italy last summer. In the 12 games since, they have steadily declined, weighed down by pressure to perform and represent. By the end, Germany under Hansi Flick began to feel like Germany under Joachim Löw as the familiar sight of a coach lost in his steadfast belief he could still save the team returned. It\'s why Flick was dismissed and why now the rebuilding must begin.\r\n\r\nWhat now?\r\n\r\nFrom a psychological perspective, one might argue that the first step was taken in Dortmund. The joy of play frees the side up to play as they can and have on occasion.\r\n\r\nWith Völler returning to his sporting director role, having fulfilled his duty and added to his legacy, the stage is set for a new coach to take the side forward. The job is to be filled by the time Germany head to the US in mid-October, which is just a month away, and the task is to build a sense of euphoria around this team ahead of a home European Championships next summer by delivering more of what was on show in Dortmund.\r\n\r\n\"We beat a world-class team tonight even if it was a friendly, it does us a world of good,\" explained Völler. \"In Wolfsburg, we felt that the supporters want it to come together for us at the EUROs. Here [in Dortmund], we knew we\'d have great support from these incredible fans.\"\r\n\r\n\"But tonight, it wasn\'t all about the result. It was about the way we played, the passion we displayed and the way we were set up — I liked what I saw.\"   \r\n\r\nGermany have never appointed a foreign coach, but perhaps now is the time. Louis van Gaal offers international experience and knows Germany well. The Dutchman is a favorite among former Bayern Munich stars Bastian Schweinsteiger and Philipp Lahm. Julian Nagelsmann is without a job but still under contract at Bayern — although Uli Hoeness recently suggested the Bundesliga champions wouldn\'t stand in the way of the young head coach if he wanted it. Whoever is chosen, their primary task will be to create a team out of this talented group of individuals.\r\n\r\n\"The best teams are those that trust each other fully,\" Gündogan said before the France game. \"We always have a positive atmosphere, but I think we can be better and more unified ... There is some timidness. Not everyone can be the way they are in their private life or at their club. That is noticeable, particularly with younger players who don\'t have the courage to open up on and off the pitch fully.\"\r\n\r\nIf players don\'t feel comfortable, then the natural question is, why? Perhaps it\'s because they don\'t feel understood — motivational videos of grey geese would support that theory. In Dortmund, Germany looked untroubled by the issue of comfort, perhaps because they had just been asked to play. \r\n\r\nTonight might have provided a much-needed spark in the form of a positive result. The real quest will be to find someone who can keep the flame burning. The next four weeks will provide the answer, and whoever the new coach is will have nine months to hold on and ensure the European Championships at home is a tournament Germany can look back on proudly.\r\n\r\nEdited by: James Thorogood"
        
        let minimumCharacterLength = 100
        let maximumCharacterLength = 200
        let diversityWeight = 0.5
        
        let summary = await summerizer.summarizeUsingExtractiveEBR(text: incomingText, minimumCharacterLength: minimumCharacterLength, maximumCharacterLength: maximumCharacterLength, diversityWeight: diversityWeight)
    
        XCTAssertNotNil(summary, "Priberam Summariser did not respond")
        
        if let summary {
            let sentences = summary.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ".").map { sentence in
                return sentence.trimmingCharacters(in: .whitespacesAndNewlines) + "."
            }
            
            XCTAssertGreaterThan(sentences.count, 0, "There should be at least one summarised sentence")
            
            // each sentence should end with a full stop (.)
            for sentence in sentences {
                XCTAssertEqual(sentence.suffix(1), ".", "The sentence should end with a full stop: '.'")
            }
        }
    }

}
