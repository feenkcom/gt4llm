Class {
	#name : #GtLDataSourceEncoderDecoderExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-DataSource-Examples'
}

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> requestWithoutEntityEncodesWithoutFailure [
	<gtExample>
	| encoderDecoder request json |
	encoderDecoder := GtLDataSourceEncoderDecoder new.
	request := ZnRequest get: 'https://example.com'.
	json := String streamContents: [ :stream |
		encoderDecoder encode: request on: stream ].
	self assert: (json includesSubstring: '"requestLine"').
	self assert: ((json includesSubstring: '"entity"') not).
	^ json
]
