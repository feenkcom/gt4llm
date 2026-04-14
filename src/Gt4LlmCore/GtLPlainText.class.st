Class {
	#name : #GtLPlainText,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLPlainText >> addContentOneLineSummaryTo: aWriteStream [
	self content ifNotNil: [ :aString | aWriteStream nextPutAll: aString asString ]
]

{ #category : #accessing }
GtLPlainText >> content [
	^ content
]

{ #category : #accessing }
GtLPlainText >> content: anObject [
	content := anObject
]

{ #category : #printing }
GtLPlainText >> gtDisplayOn: stream [ 
	content gtDisplayOn: stream 
]
