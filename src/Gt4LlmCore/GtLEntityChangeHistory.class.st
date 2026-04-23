"
I am an abstract base class for tracking code change history of a single entity.

Subclasses:
- {{gtClass:GtLMethodChangeHistory}} - for methods
- {{gtClass:GtLClassChangeHistory}} - for classes

Subclasses must implement `#changes` returning a {{gtClass:GtLSummarizerCodeChangesGroup}}.
"
Class {
	#name : #GtLEntityChangeHistory,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLEntityChangeHistory >> addChange: aCodeChange [
	self changes add: aCodeChange
]

{ #category : #accessing }
GtLEntityChangeHistory >> changes [
	"Return the collection of changes. Subclasses must implement."
	^ self subclassResponsibility
]

{ #category : #views }
GtLEntityChangeHistory >> gtCodeChangesFor: aView [
	<gtView>
	^ aView forward
		title: 'Code changes';
		priority: 20;
		object: [ self changes ];
		view: #gtCodeChangesFor:
]

{ #category : #accessing }
GtLEntityChangeHistory >> gtViewChangeEditTime [ 
	^ self latestChange  gtViewChangeEditTime
]

{ #category : #accessing }
GtLEntityChangeHistory >> gtViewChangeHistoryChildren [
	^ self changes
]

{ #category : #accessing }
GtLEntityChangeHistory >> gtViewChangesCount [
	^ self changes size
]

{ #category : #accessing }
GtLEntityChangeHistory >> latestChange [
	^ self changes ifEmpty: [ nil ] ifNotEmpty: [ self changes last ]
]
