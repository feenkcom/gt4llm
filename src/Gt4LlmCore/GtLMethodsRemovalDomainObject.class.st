Class {
	#name : #GtLMethodsRemovalDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'methods'
	],
	#category : #Gt4LlmCore
}

{ #category : #views }
GtLMethodsRemovalDomainObject >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	methods ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Methods';
		priority: 1;
		items: [ methods ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #accessing }
GtLMethodsRemovalDomainObject >> methods [
	^ methods ifNil: [ #() ]
]

{ #category : #accessing }
GtLMethodsRemovalDomainObject >> methods: aCollection [
	methods := aCollection
]

{ #category : #serialization }
GtLMethodsRemovalDomainObject >> serializeToOpenAIResponseJsonObject [
	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methods' put: (self methods collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]
