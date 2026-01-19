Class {
	#name : #GtLRefactoringMethodReferencesDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'methodName',
		'references',
		'mayHaveMore'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLRefactoringMethodReferencesDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitRefactoringMethodReferencesDomainObject: self
]

{ #category : #views }
GtLRefactoringMethodReferencesDomainObject >> gtReferencesFor: aView [
	<gtView>
	<gtLlmView>
	references ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'References';
		items: [ self references ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #accessing }
GtLRefactoringMethodReferencesDomainObject >> mayHaveMore [
	^ mayHaveMore ifNil: [ false ]
]

{ #category : #accessing }
GtLRefactoringMethodReferencesDomainObject >> mayHaveMore: aBoolean [
	"Set true if there are likely more references."

	mayHaveMore := aBoolean
]

{ #category : #accessing }
GtLRefactoringMethodReferencesDomainObject >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLRefactoringMethodReferencesDomainObject >> methodName: aString [
	"Set method name (selector) for which references are searched"

	methodName := aString
]

{ #category : #accessing }
GtLRefactoringMethodReferencesDomainObject >> references [
	^ references
]

{ #category : #accessing }
GtLRefactoringMethodReferencesDomainObject >> references: aCollection [
	"Set found references"

	references := aCollection
]

{ #category : #'api - serializing' }
GtLRefactoringMethodReferencesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methodName' put: self methodName;
		at: 'mayHaveMoreReferences' put: self mayHaveMore ;
		at: 'references'
			put: (self references
					collect: [ :eachReference | 
						String
							streamContents: [ :aStream | 
								aStream nextPutAll: eachReference modelClass name asString.
								eachReference modelClass isMeta ifTrue: [ aStream << ' class' ].
								aStream nextPutAll: '>>#'.
								aStream nextPutAll: eachReference selector ] ]
					as: Array);
		yourself
]
