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
		nextPutAll: (model 
			ifNil: [ '<missing page>' ]
			ifNotNil: [ :aPage | aPage title asString ])
]

{ #category : #printing }
GtLLepiterPageModel >> printOn: aStream [
	aStream 
			<< 'Page title: ';
			<< model title 
]
