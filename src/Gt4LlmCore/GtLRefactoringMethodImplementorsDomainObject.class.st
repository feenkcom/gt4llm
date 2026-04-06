Class {
	#name : #GtLRefactoringMethodImplementorsDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'methodName',
		'implementors'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt - extensions' }
GtLRefactoringMethodImplementorsDomainObject >> gtImplementorsFor: aView [
	<gtView>
	<gtLlmView>
	implementors ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Implementors';
		items: [ implementors ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #accessing }
GtLRefactoringMethodImplementorsDomainObject >> implementors [
	^ implementors ifNil: [ #() ]
]

{ #category : #accessing }
GtLRefactoringMethodImplementorsDomainObject >> implementors: anObject [
	implementors := anObject
]

{ #category : #'gt-llm - serialization' }
GtLRefactoringMethodImplementorsDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonObject: [ :json |
		json
			at: 'methodName' put: self methodName;
			at: 'implementors'
				put: (self implementors
						collect: [ :eachImplementor | 
							String
								streamContents: [ :aStream | 
									aStream nextPutAll: eachImplementor name asString.
									eachImplementor isMeta ifTrue: [ aStream << ' class' ] ] ]
						as: Array) ]
]

{ #category : #accessing }
GtLRefactoringMethodImplementorsDomainObject >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLRefactoringMethodImplementorsDomainObject >> methodName: anObject [
	methodName := anObject
]
