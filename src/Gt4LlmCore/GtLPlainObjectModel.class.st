Class {
	#name : #GtLPlainObjectModel,
	#superclass : #GtLWrappedModel,
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLPlainObjectModel >> addContentOneLineSummaryTo: aWriteStream [
	| aString |
	aString := [ model printString ]
			on: Error
			do: [ :e | e return: model className ].
	aWriteStream
		nextPutAll: 'Object: ';
		nextPutAll: aString asString
]

{ #category : #accessing }
GtLPlainObjectModel >> llmModelDataViewsFor: aDataView [
	<gtLlmDataView>
	
	^aDataView forwardObject 
		object: [ self targetObject]
]

{ #category : #printing }
GtLPlainObjectModel >> printOn: aStream [
	aStream 
		<< 'Plain Object: ';
		print: model 
]

{ #category : #accessing }
GtLPlainObjectModel >> targetObject [
	^ self model
]
