CREATE  FUNCTION sentiment
AS WASM FROM LOCAL INFILE 'sentiment.wasm'
WITH WIT FROM LOCAL INFILE 'sentiment.wit';

CREATE  FUNCTION sentiment_tvf RETURNS TABLE
AS WASM FROM LOCAL INFILE 'sentiment.wasm'
WITH WIT FROM LOCAL INFILE 'sentiment.wit';
