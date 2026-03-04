Class {
	#name : #GtLLepiterPageModel,
	#superclass : #GtLWrappedModel,
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLLepiterPageModel class >> forPage: aPage [
	^ self new 
		name: aPage title;
		model: aPage
]

{ #category : #adding }
GtLLepiterPageModel >> addContentOneLineSummaryTo: aWriteStream [
	aWriteStream
		nextPutAll: 'Page: ';
		nextPutAll: (model ifNotNil: [ :aPage | aPage title asString ] ifNil: [ '<missing page>' ])
]

{ #category : #adding }
GtLLepiterPageModel >> addContentTo: aDictionary [
	aDictionary 
		at: name
		put: (LeJsonV4 uniqueInstance serializePretty: model)
]

{ #category : #adding }
GtLLepiterPageModel >> addInstructionsTo: aMessageInstructions [
	"No instructions now for a Lepiter page"
]

{ #category : #printing }
GtLLepiterPageModel >> printOn: aStream [

	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << model title ]
]
