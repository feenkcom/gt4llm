Class {
	#name : #GtLLepiterPageInputModel,
	#superclass : #GtLInputModel,
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLLepiterPageInputModel class >> forPage: aPage [
	^ self new 
		name: aPage title;
		model: aPage
]

{ #category : #adding }
GtLLepiterPageInputModel >> addContentOneLineSummaryTo: aWriteStream [
	aWriteStream
		nextPutAll: 'Page: ';
		nextPutAll: (model ifNotNil: [ :aPage | aPage title asString ] ifNil: [ '<missing page>' ])
]

{ #category : #adding }
GtLLepiterPageInputModel >> addContentTo: aDictionary [
	aDictionary 
		at: name
		put: (LeJsonV4 uniqueInstance serializePretty: model)
]

{ #category : #adding }
GtLLepiterPageInputModel >> addInstructionsTo: aMessageInstructions [
	"No instructions now for a Lepiter page"
]

{ #category : #printing }
GtLLepiterPageInputModel >> printOn: aStream [

	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << model title ]
]
