"
Example-only encoder that runs a callback before encoding a request-response, allowing checkpoint observations and injected failures.
"
Class {
	#name : #GtLChatSessionWriterExampleEncoder,
	#superclass : #GtLDataSourceEncoderDecoder,
	#instVars : [
		'beforeEncode'
	],
	#category : #'Gt4Llm-DataSource-Examples'
}

{ #category : #accessing }
GtLChatSessionWriterExampleEncoder >> beforeEncode: aBlock [
	beforeEncode := aBlock
]

{ #category : #encoding }
GtLChatSessionWriterExampleEncoder >> encode: aRequestResponse on: aStream [
	beforeEncode ifNotNil: [ beforeEncode value: aRequestResponse value: aStream ].
	^ super encode: aRequestResponse on: aStream
]
