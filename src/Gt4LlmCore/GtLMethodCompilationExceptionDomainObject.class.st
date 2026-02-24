Class {
	#name : #GtLMethodCompilationExceptionDomainObject,
	#superclass : #GtLExceptionDomainObject,
	#instVars : [
		'targetClass',
		'protocolName',
		'sourceCode'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLMethodCompilationExceptionDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitMethodCompilationExceptionDomainObject: self
]

{ #category : #views }
GtLMethodCompilationExceptionDomainObject >> gtSourceCodeFor: aView [
	<gtView>
	sourceCode ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Source';
		priority: 0;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ sourceCode ]
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> protocolName [
	^ protocolName
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> protocolName: anObject [
	protocolName := anObject
]

{ #category : #'api - serializing' }
GtLMethodCompilationExceptionDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ super serializeToOpenAIResponseJsonObject
		at: #methodClass put: self targetClass name asString;
		at: #methodProtocol put: self protocolName asString;
		at: #sourceCode put: self sourceCode;
		yourself
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> targetClass: anObject [
	targetClass := anObject
]
