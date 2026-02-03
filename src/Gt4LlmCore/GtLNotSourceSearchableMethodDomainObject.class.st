Class {
	#name : #GtLNotSourceSearchableMethodDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'method'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLNotSourceSearchableMethodDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitNotSourceSearchableMethodDomainObject: self
]

{ #category : #'gt - extensions' }
GtLNotSourceSearchableMethodDomainObject >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Coder';
		priority: 10;
		stencil: [ (GtCoderElement forMethod: self method) disablePlayPage ]
]

{ #category : #accessing }
GtLNotSourceSearchableMethodDomainObject >> method [
	^ method
]

{ #category : #accessing }
GtLNotSourceSearchableMethodDomainObject >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #'api - serializing' }
GtLNotSourceSearchableMethodDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methodClass' put: self method methodClass name asString;
		at: 'selector' put: self method selector asString;
		at: 'method' put: self method name asString;
		yourself
]
