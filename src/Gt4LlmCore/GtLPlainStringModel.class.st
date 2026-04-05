Class {
	#name : #GtLPlainStringModel,
	#superclass : #GtLWrappedModel,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLPlainStringModel class >> string: aString [ 
	^ self new 
		name: 'String';
		model: aString
]

{ #category : #adding }
GtLPlainStringModel >> addContentOneLineSummaryTo: aWriteStream [

	aWriteStream
		nextPutAll: 'String: ';
		nextPutAll: model
]

{ #category : #'as yet unclassified' }
GtLPlainStringModel >> llmModelDataViewsFor: aDataView [
	<gtLlmDataView>
	^ aDataView jsonObject: [ :json | json at: self name put: self model ]
]
