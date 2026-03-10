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

{ #category : #'as yet unclassified' }
GtLPlainStringModel >> addContentTo: aDictionary [
	aDictionary
		at: name
		put: model
]

{ #category : #'as yet unclassified' }
GtLPlainStringModel >> addInstructionsTo: aMessageInstructions [

	aMessageInstructions
		addSection: (GtLInstructionSection new
				title: self name;
				body: '')
]
