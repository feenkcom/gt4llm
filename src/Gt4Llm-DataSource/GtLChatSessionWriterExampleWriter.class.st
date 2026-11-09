"
Example-only session writer injecting write, flush and rollback failures.
"
Class {
	#name : #GtLChatSessionWriterExampleWriter,
	#superclass : #GtLChatSessionWriter,
	#instVars : [
		'failureMode'
	],
	#category : #'Gt4Llm-DataSource-Examples'
}

{ #category : #private }
GtLChatSessionWriterExampleWriter >> appendBytes: bytes on: stream [
	(#(write rollback) includes: failureMode)
		ifTrue: [ stream nextPutAll: (bytes first: bytes size // 2).
			stream flush.
			Error signal: 'Injected write failure' ].
	super appendBytes: bytes on: stream
]

{ #category : #accessing }
GtLChatSessionWriterExampleWriter >> failureMode: aSymbol [
	failureMode := aSymbol
]

{ #category : #private }
GtLChatSessionWriterExampleWriter >> flushStream: stream [
	super flushStream: stream.
	failureMode = #flush ifTrue: [ Error signal: 'Injected flush failure' ]
]

{ #category : #private }
GtLChatSessionWriterExampleWriter >> rollbackTo: bytePosition [
	failureMode = #rollback ifTrue: [ Error signal: 'Injected rollback failure' ].
	super rollbackTo: bytePosition
]
