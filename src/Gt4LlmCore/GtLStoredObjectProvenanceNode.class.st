Class {
	#name : #GtLStoredObjectProvenanceNode,
	#superclass : #Object,
	#instVars : [
		'label',
		'detail',
		'target',
		'children'
	],
	#category : #'Gt4LlmCore-Object Storage'
}

{ #category : #'instance creation' }
GtLStoredObjectProvenanceNode class >> label: aLabel detail: aDetail target: anObject children: someChildren [
	^ self new
		initializeLabel: aLabel
		detail: aDetail
		target: anObject
		children: someChildren
]

{ #category : #accessing }
GtLStoredObjectProvenanceNode >> children [
	^ children
]

{ #category : #accessing }
GtLStoredObjectProvenanceNode >> detail [
	^ detail
]

{ #category : #'gt-views' }
GtLStoredObjectProvenanceNode >> gtChildrenFor: aView [
	"Which nodes are directly below this node in the provenance tree?"

	<gtView>
	^ aView columnedList
		title: 'Children';
		priority: 10;
		items: [ self children ];
		column: 'Entry' text: [ :each | each label ];
		column: 'Details' text: [ :each | each detail ]
]

{ #category : #initialization }
GtLStoredObjectProvenanceNode >> initializeLabel: aLabel detail: aDetail target: anObject children: someChildren [
	label := aLabel.
	detail := aDetail.
	target := anObject.
	children := someChildren
]

{ #category : #accessing }
GtLStoredObjectProvenanceNode >> label [
	^ label
]

{ #category : #accessing }
GtLStoredObjectProvenanceNode >> target [
	^ target
]
