Class {
	#name : #GtLMethodsSourceDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #views }
GtLMethodsSourceDomainObject >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	(self methods anySatisfy: [ :each | (each isKindOf: GtLMethodDomainObject) not ])
		ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Methods';
		priority: 1;
		object: [ GtSearchFixedMethodsFilter new
				methods: (self methods collect: [ :each | each method ]) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLMethodsSourceDomainObject >> gtMethodsListFor: aView [
	<gtView>
	<gtLlmView>
	methods ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Method list';
		priority: 2;
		items: [ methods ];
		column: 'Method' text: [ :each | each gtDisplayString ];
		column: 'Kind' text: [:each | each class name]
]

{ #category : #accessing }
GtLMethodsSourceDomainObject >> methods [
	^ methods
]

{ #category : #accessing }
GtLMethodsSourceDomainObject >> methods: aCollection [
	methods := aCollection
]

{ #category : #serialization }
GtLMethodsSourceDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methods'
			put: (self methods collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]
