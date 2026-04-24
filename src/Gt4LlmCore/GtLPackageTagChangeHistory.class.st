"
I track changes to a single package tag within a package, including its classes and methods.

Instance variables:
- `targetPackageTagName` - the name of the package tag being tracked
- `classHistories` - a GtLClassChangeHistoriesGroup containing class histories

See also:
- {{gtClass:GtLPackageChangeHistory}} - the parent package history
"
Class {
	#name : #GtLPackageTagChangeHistory,
	#superclass : #GtLEntityChangeHistory,
	#instVars : [
		'targetPackageTagName',
		'classHistories'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLPackageTagChangeHistory >> addClassHistories: aClassHistoriesGroup [
	"Add multiple class histories"
	aClassHistoriesGroup items do: [ :each |
		self addClassHistory: each ]
]

{ #category : #adding }
GtLPackageTagChangeHistory >> addClassHistory: aClassHistory [
	self classHistories addHistory: aClassHistory
]

{ #category : #accessing }
GtLPackageTagChangeHistory >> changes [
	"Return all changes from all class histories"
	| allChanges |
	allChanges := GtLSummarizerCodeChangesGroup new.
	self classHistories items do: [ :classHistory |
		allChanges addAll: classHistory changes ].
	^ allChanges
]

{ #category : #accessing }
GtLPackageTagChangeHistory >> classHistories [
	^ classHistories
]

{ #category : #printing }
GtLPackageTagChangeHistory >> gtDisplayOn: aStream [
	aStream nextPutAll: self targetPackageTagName asString
]

{ #category : #views }
GtLPackageTagChangeHistory >> gtViewChangeDescriptionElement [
	^ GtLLabeledChangeDescriptionElement new
			updateForString: self targetPackageTagName
]

{ #category : #views }
GtLPackageTagChangeHistory >> gtViewChangeEditTime [
	"Return the latest edit time across all class changes"
	| times |
	times := OrderedCollection new.
	self classHistories items do: [ :each | 
		each gtViewChangeEditTime ifNotNil: [ :t | times add: t ] ].
	^ times ifEmpty: [ nil ] ifNotEmpty: [ times max ]
]

{ #category : #views }
GtLPackageTagChangeHistory >> gtViewChangeHistoryChildren [
	^ self classHistories items
]

{ #category : #views }
GtLPackageTagChangeHistory >> gtViewChangeIcon [
	self hasNoEffect ifTrue: [
		^ Smalltalk ui icons iconNamed: #emptyPackage ].
		
	^ Smalltalk ui icons iconNamed: #package
]

{ #category : #views }
GtLPackageTagChangeHistory >> gtViewChangesCount [
	^ self classHistories items sumNumbers: [ :each | each gtViewChangesCount ]
]

{ #category : #views }
GtLPackageTagChangeHistory >> gtViewClassHistoriesFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'By class';
		priority: 35;
		object: [ self classHistories ];
		view: #gtViewHistoriesFor:
]

{ #category : #testing }
GtLPackageTagChangeHistory >> hasNoEffect [
	^ self classHistories items allSatisfy: #hasNoEffect
]

{ #category : #initialization }
GtLPackageTagChangeHistory >> initialize [
	super initialize.
	
	classHistories := GtLClassChangeHistoriesGroup new
]

{ #category : #accessing }
GtLPackageTagChangeHistory >> targetPackageTagName [
	^ targetPackageTagName
]

{ #category : #accessing }
GtLPackageTagChangeHistory >> targetPackageTagName: aString [
	targetPackageTagName := aString
]
