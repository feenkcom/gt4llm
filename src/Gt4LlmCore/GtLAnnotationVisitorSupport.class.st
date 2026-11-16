"
I answer whether a visitor of Lepiter parse trees supports an annotation node, see {{gtMethod:GtLAnnotationVisitorSupport class>>#visitor:supports:}}.
Lepiter annotations come from several grammars, one per annotation package (see {{gtMethod:LeParser class>>#annotationParsers}}). Their nodes send visit messages of their own grammar, for example `visitSymbolAnnotation:` or `visitPictureAnnotation:`, which a visitor that does not know the annotation does not understand.
{{gtClass:GtLTextSnippetExporter}} and {{gtClass:GtLMessageStyler}} ask me before they visit an annotation, and treat an unsupported one as plain text instead of failing.
I am gt4llm's own copy of the check that Lepiter uses for its export visitors ({{gtMethod:TLeExtensibleContentNodeVisitor>>#doesAnnotationVisitor:support:}}), so gt4llm does not depend on that Lepiter helper.
See {{gtExample:GtLTextSnippetExporterExamples>>#allAnnotationsKeepTheirSource}} and {{gtExample:GtLMessageStylerExamples>>#allAnnotationsDoNotFail}}.
"
Class {
	#name : #GtLAnnotationVisitorSupport,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Exporter'
}

{ #category : #testing }
GtLAnnotationVisitorSupport class >> visitor: aVisitor supports: anAnnotationNode [
	"Answer true if aVisitor can visit anAnnotationNode: aVisitor uses the node's visitor trait,
	or it understands every visit message the node sends in its #acceptVisitor: method.
	Error nodes (unknown or malformed annotations) are not supported."

	<return: #Boolean>
	| aMethod theSelectors |
	anAnnotationNode ifNil: [ ^ false ].
	anAnnotationNode isErrorNode ifTrue: [ ^ false ].

	(aVisitor class allTraits includes: anAnnotationNode visitorTrait)
		ifTrue: [ ^ true ].

	aMethod := anAnnotationNode class lookupSelector: #acceptVisitor:.
	aMethod ifNil: [ ^ false ].
	theSelectors := aMethod messages select: [ :eachSelector | eachSelector beginsWith: 'visit' ].

	^ theSelectors notEmpty
		and: [ theSelectors allSatisfy: [ :eachSelector | aVisitor respondsTo: eachSelector ] ]

]
