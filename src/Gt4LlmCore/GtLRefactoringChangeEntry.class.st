"
I am one change listed in the groups of a refactoring report (see {{gtClass:GtLRefactoringChangeGroupsReport}}). A preview gets its entries from its changes ({{gtMethod:GtLRefactoringChange>>#asChangeEntry}}, which asks the RB change for its gtLlmNewChangeEntry); a result gets them from its code change results (llmChangeEntry), as these tell what changed in the image, and from the previewed Lepiter changes.

My subclasses name the changed class, method, Lepiter snippet or other entity in {{gtMethod:GtLRefactoringChangeEntry>>#addTargetPropertiesTo:}}. I always know my new source; the report decides whether it is listed ({{gtMethod:GtLRefactoringChangeEntry>>#llmJsonObjectIncludingSources:}}).
"
Class {
	#name : #GtLRefactoringChangeEntry,
	#superclass : #Object,
	#instVars : [
		'kind',
		'newSource'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #converting }
GtLRefactoringChangeEntry >> addTargetPropertiesTo: aJsonObject [
	"Add the properties that name the changed class, method, snippet or other entity"

	self subclassResponsibility
]

{ #category : #accessing }
GtLRefactoringChangeEntry >> groupKind [
	"Return the group of changes I belong to: #class, #method, #lepiter or #other"

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLRefactoringChangeEntry >> kind [
	^ kind
]

{ #category : #accessing }
GtLRefactoringChangeEntry >> kind: aString [
	kind := aString
]

{ #category : #converting }
GtLRefactoringChangeEntry >> llmJsonObjectIncludingSources: aBoolean [
	"Properties without a value are left out, and so is the new source when it is not wanted"

	| json |
	json := NeoJSONObject new.
	kind ifNotNil: [ :aKind | json at: 'kind' put: aKind ].
	self addTargetPropertiesTo: json.
	(aBoolean and: [ newSource notNil ])
		ifTrue: [ json at: 'newSource' put: newSource ].
	^ json
]

{ #category : #accessing }
GtLRefactoringChangeEntry >> newSource [
	^ newSource
]

{ #category : #accessing }
GtLRefactoringChangeEntry >> newSource: aStringOrNil [
	newSource := aStringOrNil
]

{ #category : #printing }
GtLRefactoringChangeEntry >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				nextPutAll: (self kind ifNil: [ '' ]);
				space;
				nextPutAll: (self target ifNil: [ '' ]) ]
]

{ #category : #accessing }
GtLRefactoringChangeEntry >> target [
	"Return the class, method, snippet or other entity I describe, as a string"

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLRefactoringChangeEntry >> useNewClassNames: aDictionary [
	"List me under the new names of the classes my refactoring renames, as aDictionary maps them from their old names"

	
]
