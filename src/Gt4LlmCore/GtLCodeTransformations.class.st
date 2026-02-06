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

{ #category : #'api - ui' }
GtLCodeTransformations >> contentOneLineMultiLabelSummaryWith: aBuilder [
	self transformations
		do: [ :each | each contentOneLineMultiLabelSummaryWith: aBuilder ]
]
