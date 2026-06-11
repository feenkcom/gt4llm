Class {
	#name : #GtLAgents,
	#superclass : #GtBasicGroup,
	#category : #'Gt4LlmCore-Agents'
}

{ #category : #'instance creation' }
GtLAgents class >> gt [
	^ self withAll: { GtLSystemExplorationAgent new. GtLGeneralPurposeAgent new }
]

{ #category : #'gt-extensions' }
GtLAgents >> gtItemsFor: aView [
	<gtView>
	
	^aView columnedList
		title: 'Agents';
		priority: 20;
		items: [ self asOrderedCollection ];
		column: 'Name' text: [ :each | each name ] width: 200;
		column: 'Model' text: [ :each | each modelName ifNil: [ '-' ] ] width: 200;
		column: 'Description' text: [ :each | each description ];
		actionUpdateButtonTooltip: 'Update agent list'
]
