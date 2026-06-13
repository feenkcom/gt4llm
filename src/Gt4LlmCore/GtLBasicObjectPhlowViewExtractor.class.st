Class {
	#name : #GtLBasicObjectPhlowViewExtractor,
	#superclass : #Object,
	#instVars : [
		'targetObject',
		'viewSelector'
	],
	#category : #'Gt4LlmCore-Phlow'
}

{ #category : #'instance creation' }
GtLBasicObjectPhlowViewExtractor class >> forTargetObject: anObject [
	^ self new 
		targetObject: anObject
]

{ #category : #testing }
GtLBasicObjectPhlowViewExtractor class >> isAbstract [
	^ self name = #GtLBasicObjectPhlowViewExtractor
]

{ #category : #api }
GtLBasicObjectPhlowViewExtractor >> computePhlowViewDomainObjectOnError: anErrorBlock [
	^ self subclassResponsibility
]

{ #category : #api }
GtLBasicObjectPhlowViewExtractor >> phlowViewDomainObjectOnError: anErrorBlock [
	^ [ 
			GtProcessStackOverflowChecker currentCheckerClass
				checkDuring: [ 
					self computePhlowViewDomainObjectOnError: anErrorBlock  ] 
		]
			on: Error
			do: [ :anError | ^ anErrorBlock value: (GtLExceptionDomainObject freeze: anError) ].
]

{ #category : #accessing }
GtLBasicObjectPhlowViewExtractor >> targetObject [
	^ targetObject
]

{ #category : #accessing }
GtLBasicObjectPhlowViewExtractor >> targetObject: anObject [
	targetObject := anObject
]

{ #category : #accessing }
GtLBasicObjectPhlowViewExtractor >> viewSelector [
	^ viewSelector
]

{ #category : #accessing }
GtLBasicObjectPhlowViewExtractor >> viewSelector: anObject [
	viewSelector := anObject
]
