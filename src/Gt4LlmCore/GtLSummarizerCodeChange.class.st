"
Represents a code change detected by a tool call summarizer, linking the change kind, the change result and the originating tool call.
"
Class {
	#name : #GtLSummarizerCodeChange,
	#superclass : #Object,
	#instVars : [
		'label',
		'changeResult',
		'toolCall'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLSummarizerCodeChange >> changeResult [
	^ changeResult
]

{ #category : #accessing }
GtLSummarizerCodeChange >> changeResult: anObject [
	changeResult := anObject
]

{ #category : #printing }
GtLSummarizerCodeChange >> gtDisplayOn: aStream [
	aStream
		nextPutAll: self label;
		nextPutAll: ': ';
		nextPutAll: self changeResult gtDisplayString
]

{ #category : #accessing }
GtLSummarizerCodeChange >> label [
	^ label
]

{ #category : #accessing }
GtLSummarizerCodeChange >> label: aString [
	label := aString
]

{ #category : #accessing }
GtLSummarizerCodeChange >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLSummarizerCodeChange >> toolCall: aToolCall [
	toolCall := aToolCall
]
