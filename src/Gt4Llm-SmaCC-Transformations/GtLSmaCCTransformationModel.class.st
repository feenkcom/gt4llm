Class {
	#name : #GtLSmaCCTransformationModel,
	#superclass : #Object,
	#instVars : [
		'files'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Model'
}

{ #category : #accessing }
GtLSmaCCTransformationModel >> files [
	^ files
]

{ #category : #private }
GtLSmaCCTransformationModel >> fixFileReferencesIn: aFileSpec [
	aFileSpec rules
		doWithIndex: [ :each :i | 
			each isRewriteFile
				ifTrue: [ files
						at: each filename asFileReference
						ifPresent: [ :loaded | aFileSpec at: i put: loaded ]
						ifAbsent: [ files at: each filename asFileReference put: each ].
					self fixFileReferencesIn: each.
					aFileSpec rules
						at: i
						put: (GtLSmaCCRewriteFileReferenceSpecification new
								filename: each filename;
								yourself) ] ]
]

{ #category : #initialization }
GtLSmaCCTransformationModel >> initialize [
	super initialize.
	files := Dictionary new
]

{ #category : #accessing }
GtLSmaCCTransformationModel >> specificationFor: aFilename [
	| ref |
	ref := aFilename asFileReference.
	^ files
		at: ref
		ifAbsentPut: [ (ref exists
				ifTrue: [ [ | spec |
					spec := (SmaCCRewriteRuleFileParser parseFile: ref) asLlmSpecification.
					self fixFileReferencesIn: spec.
					spec ] on: Error do: [ :ex | ex return ] ])
				ifNil: [ GtLSmaCCRewriteFileSpecification new filename: ref path pathString ] ]
]
