Class {
	#name : #GtLWrappedObjectModel,
	#superclass : #GtLWrappedModel,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLWrappedObjectModel >> addContentOneLineSummaryTo: aWriteStream [
	| aString |
	aString := [ model printString ]
		on: Error
		do: [ :e | e return: model className ].
	aWriteStream
		nextPutAll: 'Object: ';
		nextPutAll: aString asString
]

{ #category : #views }
GtLWrappedObjectModel >> llmModelDataViewsFor: aDataView [
	<gtLlmDataView>
	
	^aDataView forwardObject 
		object: [ self targetObject]
]

{ #category : #printing }
GtLWrappedObjectModel >> printOn: aStream [
	aStream 
		<< 'Wrapped Object: ';
		print: model
]

{ #category : #accessing }
GtLWrappedObjectModel >> targetObject [
	^ self model
]
