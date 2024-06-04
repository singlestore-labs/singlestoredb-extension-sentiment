wit_bindgen_rust::export!("sentiment.wit");
struct Sentiment;
use crate::sentiment::PolarityScores;

impl sentiment::Sentiment for Sentiment {

    fn sentiment(input: String) -> PolarityScores {
        lazy_static::lazy_static! {
            static ref ANALYZER: vader_sentiment::SentimentIntensityAnalyzer<'static> =
                vader_sentiment::SentimentIntensityAnalyzer::new();
        }

        let scores = ANALYZER.polarity_scores(input.as_str());
        PolarityScores {
            compound: scores["compound"],
            positive: scores["pos"],
            negative: scores["neg"],
            neutral: scores["neu"],
        }
    }

    fn sentiment_tvf(input: String) -> Vec<PolarityScores> {
        lazy_static::lazy_static! {
            static ref ANALYZER: vader_sentiment::SentimentIntensityAnalyzer<'static> =
                vader_sentiment::SentimentIntensityAnalyzer::new();
        }

        let scores = ANALYZER.polarity_scores(input.as_str());
        vec![
            PolarityScores {
                compound: scores["compound"],
                positive: scores["pos"],
                negative: scores["neg"],
                neutral: scores["neu"],
            }
        ]
    }
}

