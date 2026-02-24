Class {
	#name : #GtLMethodDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'method'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLMethodDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitMethodDomainObject: self
]

{ #category : #'gt - extensions' }
GtLMethodDomainObject >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Coder';
		priority: 1;
		stencil: [ (GtCoderElement forMethod: self method) disablePlayPage ]
]

{ #category : #accessing }
GtLMethodDomainObject >> method [
	^ method
]

{ #category : #accessing }
GtLMethodDomainObject >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #'api - serializing' }
GtLMethodDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methodClass' put: self method methodClass name asString;
		at: 'selector' put: self method selector asString;
		at: 'method' put: self method name asString;
		at: 'sourceCode' put: self sourceCode;
		yourself
]

{ #category : #'as yet unclassified' }
GtLMethodDomainObject >> sourceCode [
	^ self method sourceCode.
]

{ #category : #'as yet unclassified' }
GtLMethodDomainObject >> targetClass [
	^ method methodClass
]
