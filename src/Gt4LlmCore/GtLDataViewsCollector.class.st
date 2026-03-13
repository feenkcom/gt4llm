Class {
	#name : #GtLDataViewsCollector,
	#superclass : #GtPhlowCollector,
	#instVars : [
		'context'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLDataViewsCollector class >> defaultPragmaNames [
	^ #( #gtLlmDataView )
]

{ #category : #'as yet unclassified' }
GtLDataViewsCollector >> collect [
	<return: #Array of: #GtLDataView>
	<gtCollector>
	
	| dataViews |
	
	dataViews := self collectPragmas 
		collect: [:eachPragma |
			GtProcessStackOverflowChecker currentCheckerClass 
				checkDuring: [
					GtLDataView empty
								on: self object
								perform: eachPragma methodSelector
								withContext: self context] ].
	
	self sortByPriority: dataViews.
	
	^dataViews
]

{ #category : #accessing }
GtLDataViewsCollector >> context [
	^context
]

{ #category : #accessing }
GtLDataViewsCollector >> context: anObject [
	context := anObject
]

{ #category : #defaults }
GtLDataViewsCollector >> defaultPragmaNames [
	^ self class defaultPragmaNames
]
