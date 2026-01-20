Class {
	#name : #GtLRefactoringMethodImplementorsDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'methodName',
		'implementors'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLRefactoringMethodImplementorsDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitRefactoringMethodImplementorsDomainObject: self
]

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

{ #category : #accessing }
GtLRefactoringMethodImplementorsDomainObject >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLRefactoringMethodImplementorsDomainObject >> methodName: anObject [
	methodName := anObject
]

{ #category : #'api - serializing' }
GtLRefactoringMethodImplementorsDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methodName' put: self methodName;
		at: 'implementors'
			put: (self implementors
					collect: [ :eachImplementor | 
						String
							streamContents: [ :aStream | 
								aStream nextPutAll: eachImplementor name asString.
								eachImplementor isMeta ifTrue: [ aStream << ' class' ] ] ]
					as: Array);
		yourself
]
