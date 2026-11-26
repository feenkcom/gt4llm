Class {
	#name : #GtLCodeTransformations,
	#superclass : #GtLBasicTransformations,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'api - ui' }
GtLCodeTransformations >> addContentOneLineSummaryTo: aWriteStream [
	self transformations
		do: [ :each | each addContentOneLineSummaryTo: aWriteStream ]
		separatedBy: [ aWriteStream space ]
]

{ #category : #accessing }
GtLCodeTransformations >> allowedTransformationClasses [
	^ GtLCodeTransformationSpecification allSubclasses 
			select: #isConcrete
]

{ #category : #converting }
GtLCodeTransformations >> applyRefactoring [
	"A refactoring can change a method more than once: a method rename adds the renamed implementor and then rewrites its sends of the selector, and changes the old implementor before removing it. Keep only the last change of each method, as the image ends up with it, so that the preview, the result and the undo change each method once"

	| namespace |
	namespace := super applyRefactoring.
	namespace gtCleanupChanges.
	^ namespace
]

{ #category : #'api - ui' }
GtLCodeTransformations >> contentOneLineMultiLabelSummaryWith: aBuilder [
	self transformations
		do: [ :each | each contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #validation }
GtLCodeTransformations >> gtProblems [
	"The transformations are checked in order, so that a class added by an earlier one is known"

	| addedNames |
	addedNames := Set new.
	^ (transformations
		flatCollect: [ :each | 
			| problems |
			problems := each gtProblemsAfterAdding: addedNames.
			each addedClassName ifNotNil: [ :aName | addedNames add: aName asString ].
			problems ]) , self orderProblems
]

{ #category : #accessing }
GtLCodeTransformations >> orderProblems [
	"Each transformation is checked against the image as it is, but they run in order. After a RenameClass, a transformation can name its class neither by the old name, which no longer exists then, nor by the new one, which does not exist yet when it is checked.
	These are precondition problems: they come from checking the transformations against the image instead of in the namespace where the earlier ones already ran. Once the preconditions are checked in that namespace, the order is enforced there and these problems go away"

	| oldNames newNames |
	oldNames := Set new.
	newNames := Dictionary new.
	^ Array
		streamContents: [ :aStream | 
			transformations
				do: [ :each | 
					each usedClassNames
						do: [ :aName | 
							| aClassName |
							aClassName := GtLCodeTransformationSpecification
									instanceSideNameOf: aName.
							(oldNames includes: aClassName)
								ifTrue: [ aStream
										nextPut: (GtLTransformationPreconditionProblem
												description: each class jsonSchemaLabel , ' on ' , aClassName
														, ' comes after the RenameClass of ' , aClassName
														, ': put it before the RenameClass, with the current name') ].
							newNames
								at: aClassName
								ifPresent: [ :anOldName | 
									aStream
										nextPut: (GtLTransformationPreconditionProblem
												description: each class jsonSchemaLabel , ' names ' , aClassName , ', the new name of '
														, anOldName
														, ': put it before the RenameClass, with the current name '
														, anOldName) ] ].
					each classRename
						ifNotNil: [ :aRename | 
							oldNames add: aRename key asString.
							newNames at: aRename value asString put: aRename key asString ] ] ]
]
