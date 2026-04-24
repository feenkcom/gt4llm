"
I track changes to a single package, including its package tags with their classes and methods.

Instance variables:
- `targetPackageName` - the name of the package being tracked
- `packageTagHistories` - a {{gtClass:GtLPackageTagChangeHistoriesGroup}} containing package tag histories

The hierarchy is: Package → Package Tag → Class → Method → Individual changes.
Classes without an explicit package tag are grouped under 'Unclassified'.

See also:
- {{gtClass:GtEpiceaPackageHistory}} - similar concept in Epicea
- {{gtClass:GtLPackageTagChangeHistory}} - the package tag level history
"
Class {
	#name : #GtLPackageChangeHistory,
	#superclass : #GtLEntityChangeHistory,
	#instVars : [
		'targetPackageName',
		'packageTagHistories'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLPackageChangeHistory >> addPackageTagHistories: aPackageTagHistoriesGroup [
	"Add multiple package tag histories"
	aPackageTagHistoriesGroup items do: [ :each |
		self addPackageTagHistory: each ]
]

{ #category : #adding }
GtLPackageChangeHistory >> addPackageTagHistory: aPackageTagHistory [
	self packageTagHistories addHistory: aPackageTagHistory
]

{ #category : #accessing }
GtLPackageChangeHistory >> changes [
	"Return all changes from all package tag histories"
	| allChanges |
	allChanges := GtLSummarizerCodeChangesGroup new.
	self packageTagHistories items do: [ :tagHistory |
		allChanges addAll: tagHistory changes ].
	^ allChanges
]

{ #category : #accessing }
GtLPackageChangeHistory >> classHistories [
	"Return all class histories across all package tags"
	| allClassHistories |
	allClassHistories := GtLClassChangeHistoriesGroup new.
	self packageTagHistories items do: [ :tagHistory |
		allClassHistories addAll: tagHistory classHistories items ].
	^ allClassHistories
]

{ #category : #printing }
GtLPackageChangeHistory >> gtDisplayOn: aStream [
	aStream nextPutAll: self targetPackageName
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangeDescriptionElement [
	^ GtLLabeledChangeDescriptionElement new
			updateForString: self targetPackageName
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangeEditTime [
	"Return the latest edit time across all class changes"
	| times |
	times := OrderedCollection new.
	self classHistories items do: [ :each | 
		each gtViewChangeEditTime ifNotNil: [ :t | times add: t ] ].
	^ times ifEmpty: [ nil ] ifNotEmpty: [ times max ]
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangeHistoryChildren [
	^ self packageTagHistories items
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangeIcon [
	self hasNoEffect ifTrue: [
		^ Smalltalk ui icons iconNamed: #emptyPackage ].
		
	^ Smalltalk ui icons iconNamed: #package
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangesCount [
	^ self packageTagHistories items sumNumbers: [ :each | each gtViewChangesCount ]
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewClassHistoriesFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'By class';
		priority: 35;
		object: [ self classHistories ];
		view: #gtViewHistoriesFor:
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewPackageTagHistoriesFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'By tag';
		priority: 30;
		object: [ self packageTagHistories ];
		view: #gtViewHistoriesFor:
]

{ #category : #testing }
GtLPackageChangeHistory >> hasNoEffect [
	^ self packageTagHistories items allSatisfy: #hasNoEffect
]

{ #category : #initialization }
GtLPackageChangeHistory >> initialize [
	super initialize.
	packageTagHistories := GtLPackageTagChangeHistoriesGroup new
]

{ #category : #accessing }
GtLPackageChangeHistory >> packageTagHistories [
	^ packageTagHistories
]

{ #category : #accessing }
GtLPackageChangeHistory >> targetPackageName [
	^ targetPackageName
]

{ #category : #accessing }
GtLPackageChangeHistory >> targetPackageName: aPackageName [
	targetPackageName := aPackageName
]
