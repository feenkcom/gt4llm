Extension { #name : #RBRenameClassChange }

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	"Record the rename, the classes whose definition names the renamed class, then the changes of the methods that reference the class"

	aChangeTargets renameClassNamed: self oldName to: self newName.
	self gtLlmClassesWithDefinitionsReferringToChangeClass
		do: [ :each | aChangeTargets addClassNamed: each name ].
	super gtLlmAddChangeTargetsTo: aChangeTargets
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmChangeKind [
	^ 'renamed class'
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmChangeTarget [
	^ self oldName asString , ' to ' , self newName asString
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmClassesWithDefinitionsReferringToChangeClass [
	"Return the classes and traits whose definition names the renamed class: its direct subclasses and, for a trait, its users (also on the class side only)"

	| aClass classes |
	aClass := self changeClass ifNil: [ ^ #() ].
	aClass := aClass instanceSide.
	classes := IdentitySet withAll: aClass subclasses.
	aClass isTrait
		ifTrue: [ classes
				addAll: aClass users;
				addAll: aClass classTrait users ].
	^ ((classes collect: [ :each | each instanceSide ]) asSet
		asSortedCollection: [ :a :b | a name <= b name ]) asArray
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	"After a rename, the class change result is about the class with its new name"

	^ aCodeChangeResult isClassChangeResult
		and: [ aCodeChangeResult targetClassName asString = self newName asString ]
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringClassChangeEntry new
		className: self oldName asString;
		newClassName: self newName asString;
		yourself
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmPreviewChanges [
	"Describe the rename, the definitions that refer to the renamed class, and my nested changes.
	The nested changes keep the old class name until they are executed; describe them under the new name, as their results are reported, but compute their kind against the current image"

	| changes |
	changes := OrderedCollection with: (GtLRefactoringChange fromChange: self).
	self gtLlmClassesWithDefinitionsReferringToChangeClass
		do: [ :each | 
			changes
				add: (GtLRefactoringChange
						fromChange: (GtLRefactoringDefinitionChange
								forClass: each
								renaming: self oldName
								to: self newName)) ].
	self changes
		do: [ :eachChange | 
			eachChange gtBasicChanges
				do: [ :eachBasicChange | 
					changes
						add: (GtLRefactoringChange
								fromChange: eachBasicChange
								matchingChange: (eachBasicChange
										renameChangesForClass: self oldName asSymbol
										to: self newName asSymbol)) ] ].
	^ changes asArray
]
