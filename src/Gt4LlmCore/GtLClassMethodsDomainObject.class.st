Class {
	#name : #GtLClassMethodsDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'targetClass',
		'methods'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLClassMethodsDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitClassMethodsDomainObject: self
]

{ #category : #'gt - extensions' }
GtLClassMethodsDomainObject >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Class';
		priority: 10;
		stencil: [ (GtCoderElement forClass: self targetClass) disablePlayPage ]
]

{ #category : #accessing }
GtLClassMethodsDomainObject >> methods [
	^ methods
]

{ #category : #accessing }
GtLClassMethodsDomainObject >> methods: anObject [
	methods := anObject
]

{ #category : #'api - serializing' }
GtLClassMethodsDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'className' put: self targetClass name;
		at: 'methods'
			put: (self methods
					collect: [ :eachMethod | eachMethod methodClass name asString , '>>#' , eachMethod selector ]
					as: Array);
		yourself
]

{ #category : #accessing }
GtLClassMethodsDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLClassMethodsDomainObject >> targetClass: anObject [
	targetClass := anObject
]
