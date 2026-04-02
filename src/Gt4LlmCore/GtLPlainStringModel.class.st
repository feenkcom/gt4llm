Class {
	#name : #GtLPlainStringModel,
	#superclass : #GtLWrappedModel,
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLPlainStringModel >> addContentOneLineSummaryTo: aWriteStream [

	aWriteStream
		nextPutAll: 'String: ';
		nextPutAll: model
]
