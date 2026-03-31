Class {
	#name : #GtLPlainObjectModel,
	#superclass : #GtLWrappedModel,
	#instVars : [
		'mainDataView'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLPlainObjectModel class >> forObject: anObject named: aName [
	^self new 
		initializeForObject: anObject named: aName
]

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

{ #category : #adding }
GtLPlainObjectModel >> addContentTo: aDictionary [
	aDictionary
		at: name
		put: (self mainDataView serializeToLlmPrimiteData compositeJsonData)
]

{ #category : #adding }
GtLPlainObjectModel >> addInstructionsTo: aMessageInstructions [

]

{ #category : #initialization }
GtLPlainObjectModel >> computeMainDataView [
	^(self model llmDataViewsFor: GtLDataView new)
		title: self name
]

{ #category : #initialization }
GtLPlainObjectModel >> initializeForObject: anObject named: aName [
	self model: anObject.
	self name: aName.
	self mainDataView: self computeMainDataView
]

{ #category : #accessing }
GtLPlainObjectModel >> mainDataView [
	^mainDataView ifNil: [
		mainDataView := self computeMainDataView ]
]

{ #category : #accessing }
GtLPlainObjectModel >> mainDataView: aDataView [
	mainDataView := aDataView
]

{ #category : #serialization }
GtLPlainObjectModel >> serializeToAnthropicResponseOutput [
	^ self mainDataView  serializeToAnthropicResponseOutput
]

{ #category : #serialization }
GtLPlainObjectModel >> serializeToOpenAIResponseOutput [
	^ self mainDataView  serializeToOpenAIResponseOutput
]

{ #category : #accessing }
GtLPlainObjectModel >> targetDataViews: aCollection [
	self mainDataView: (GtLCompositeDataView new 
		title: (self name ifNil: ['Object views']);
		addDataViews: aCollection)
]

{ #category : #'as yet unclassified' }
GtLPlainObjectModel >> targetObject [
	^ self model
]
