Class {
	#name : #GtLMcpResources,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #'gt - extensions' }
GtLMcpResources >> gtResourcesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Resources';
		items: [ self items ];
		column: 'Name' text: [ :each | each name ifNil: [ '' ] ];
		column: 'Description' text: [ :each | each description ifNil: [ '' ] ]
]
