<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<template:addResources type="css" resources="wem.css" />
<template:addResources type="javascript" resources="wem.js" />
<jcr:nodeProperty node="${currentNode}" name="j:segments" var="segmentList"/>
<c:set var="elementID" value="segment-${currentNode.identifier}" />

<div class="segmentContainer" id="${elementID}" style="display:none">
    <div class="segmentContent">
      ${wrappedContent}
    </div>
    <div class="segmentOverlay"> <fmt:message key="label.segments.selected.overlay"/> </div>
</div>

<script type="text/javascript">

    (function () {

        var editMode = ${renderContext.editMode ? 'true' : 'false'};

        var divElement = document.getElementById("${elementID}");

        var waitingCount = 0;

        console.log("divElement=" + divElement);

        if (editMode) {
            divElement.classList.add("segmentContainerEdit");
            divElement.setAttribute("style","display:block");
            return;
        }

        var segmentList = [
            <c:forEach items="${segmentList}" var="segment" varStatus="segmentStatus">
            '${segment.string}' <c:if test="${!segmentStatus.last}">, </c:if>
            </c:forEach>
        ];

        console.log('Server segmentList=' + segmentList);

        function contains(a, obj) {
            for (var i = 0; i < a.length; i++) {
                if (a[i] === obj) {
                    return true;
                }
            }
            return false;
        }

        function digitalDataLoaded(digitalData) {
            console.log("Digital data object is loaded");
            if (digitalData.user && digitalData.user[0]) {
                if (digitalData.user[0].profiles && digitalData.user[0].profiles[0]) {
                    userSegments = digitalData.user[0].profiles[0].profileInfo.segments;
                    console.log("User segments=" + userSegments);
                    var found = false;
                    for (var i=0; i < segmentList.length; i++) {
                        if (contains(userSegments, segmentList[i])) {
                            console.log(segmentList[i] + " is part of user segments " + userSegments);
                            divElement.setAttribute("style","display:block");
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        console.log("No matching segment found !");
                    }
                }
            }
        }

        function digitalDataUpdated(digitalData) {
            console.log("Digital data object was updated");
            if (digitalData.user && digitalData.user[0]) {
                if (digitalData.user[0].profiles && digitalData.user[0].profiles[0]) {
                    userSegments = digitalData.user[0].profiles[0].profileInfo.segments;
                    console.log("User segments=" + userSegments);
                    var found = false;
                    for (var i=0; i < segmentList.length; i++) {
                        if (contains(userSegments, segmentList[i])) {
                            console.log(segmentList[i] + " is part of user segments " + userSegments);
                            divElement.setAttribute("style","display:block");
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        console.log("No matching segment found !");
                    }
                }
            }
        }

        wem.registerCallbacks(digitalDataLoaded, digitalDataUpdated);

    })();

</script>
