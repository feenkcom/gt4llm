Class {
	#name : #GtLMethodsSourceDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #views }
GtLMethodsSourceDomainObject >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Methods';
		priority: 1;
		object: [ GtSearchFixedMethodsFilter new methods: (self methods 
			collect: [ :each | each method ]) ];
		view: #gtItemsFor:
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
