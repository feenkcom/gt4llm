Class {
	#name : #GtLlmConnection,
	#superclass : #Object,
	#instVars : [
		'provider',
		'model',
		'label'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmConnection >> = anotherConnection [
	^ self model = anotherConnection model
		and: [ self provider = anotherConnection provider ]
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> buildProvider [
	^ self provider default value model: self model
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> connectionString [
	^ self label ifNil: [ self model ]
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> details [
	^ {'Provider' -> self provider providerName.
		'Model' -> self model.
		'Label' -> self label}
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ self details ];
		column: 'Property' text: #key;
		column: 'Value' text: #value
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> hash [
	^ self model hash xor: self provider hash
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> isConnectable [
	^ self provider isConnectable
]

{ #category : #accessing }
GtLlmConnection >> label [
	^ label
]

{ #category : #accessing }
GtLlmConnection >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtLlmConnection >> model [
	^ model
]

{ #category : #accessing }
GtLlmConnection >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmConnection >> provider [
	^ provider
]

{ #category : #accessing }
GtLlmConnection >> provider: anObject [
	provider := anObject
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> providerName [
	^ self provider providerName
]
