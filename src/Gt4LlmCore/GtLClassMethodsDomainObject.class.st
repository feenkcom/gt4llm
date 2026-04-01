Class {
	#name : #GtLClassMethodsDomainObject,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'methods'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt - extensions' }
GtLClassMethodsDomainObject >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Class';
		priority: 10;
		stencil: [ (GtCoderElement forClass: self targetClass) disablePlayPage ]
]

{ #category : #'gt - extensions' }
GtLClassMethodsDomainObject >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	methods ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Methods';
		items: [ self methods ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #'llm views' }
GtLClassMethodsDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonObject: [ :json |
		json
			at: 'className' put: self targetClass name;
			at: 'methods' put: (self methods
				collect: [ :eachMethod | 
					eachMethod methodClass name asString, '>>#', eachMethod selector ]
				as: Array) ]
]

{ #category : #accessing }
GtLClassMethodsDomainObject >> methods [
	^ methods ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassMethodsDomainObject >> methods: anObject [
	methods := anObject
]

{ #category : #accessing }
GtLClassMethodsDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLClassMethodsDomainObject >> targetClass: anObject [
	targetClass := anObject
]
