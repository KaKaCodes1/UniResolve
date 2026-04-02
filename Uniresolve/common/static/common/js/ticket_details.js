/**
 * ticket_details.js
 * Contains the shared populateDetails function used across 
 * Student, Staff, and Admin ticket detail views.
 */

function populateDetails(ticket) {
    // Breadcrumb & Headers
    const ticketYear = new Date(ticket.created_at).getFullYear();
    const displayId = `TICK-${ticketYear}-${ticket.id}`;

    const breadcrumbIdEl = document.getElementById('breadcrumbId');
    if (breadcrumbIdEl) breadcrumbIdEl.textContent = `Ticket ${displayId}`;
    
    const detailTitleEl = document.getElementById('detailTitle');
    if (detailTitleEl) detailTitleEl.textContent = ticket.title;
    
    const detailIdEl = document.getElementById('detailId');
    if (detailIdEl) detailIdEl.textContent = displayId;

    // Optional Escalation Modal Title (Staff context)
    const escTitle = document.getElementById('escTicketTitle');
    if (escTitle) escTitle.textContent = ticket.title;

    // Meta Info
    const detailCategoryEl = document.getElementById('detailCategory');
    if (detailCategoryEl) detailCategoryEl.textContent = ticket.category_name;
    
    // Admin/Staff show owner of the ticket
    const detailOwnerEl = document.getElementById('detailOwner');
    if (detailOwnerEl) detailOwnerEl.textContent = ticket.owner || 'N/A';

    const detailDueDateEl = document.getElementById('detailDueDate');
    if (detailDueDateEl) {
        const dueDate = new Date(ticket.due_date);
        detailDueDateEl.textContent = dueDate.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' , hour: '2-digit', minute: '2-digit' });
    }

    const dateObj = new Date(ticket.created_at);
    const detailDateEl = document.getElementById('detailDate');
    if (detailDateEl) {
        detailDateEl.textContent = dateObj.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' });
    }

    // Status Badge
    const statusEl = document.getElementById('detailStatus');
    if (statusEl) {
        statusEl.textContent = ticket.status;
        statusEl.className = `status-badge status-${ticket.status.toLowerCase()}`;
    }

    // Description & Initial Attachment
    const descEl = document.getElementById('detailDescription');
    if (descEl) descEl.textContent = ticket.description;

    const attachmentSection = document.getElementById('detailAttachmentSection');
    if (attachmentSection) {
        if (ticket.attachment) {
            attachmentSection.style.display = 'block';
            const link = document.getElementById('detailAttachmentLink');
            if (link) link.href = ticket.attachment;
            
            const nameEl = document.getElementById('detailAttachmentName');
            if (nameEl) nameEl.textContent = ticket.attachment.split('/').pop();
        } else {
            attachmentSection.style.display = 'none';
        }
    }

    // Additional Information 
    const addInfoSection = document.getElementById('additionalInfoSection');
    const addInfoFormSection = document.getElementById('additionalInfoFormSection');
    
    if (addInfoSection) {
        let addInfoContent = document.getElementById('additionalInfoContent'); 
        
        // Render History
        if (addInfoContent) {
            if (ticket.additional_info && ticket.additional_info.length > 0) {
                addInfoSection.style.display = 'block';
                addInfoContent.innerHTML = ''; // clear loading state
                
                // Sort to show newest first
                //Using spread operator to avoid mutating the original array
                const sortedInfo = [...ticket.additional_info].sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
                
                sortedInfo.forEach(info => {
                    const infoDate = new Date(info.created_at);
                    const timeString = `${infoDate.toLocaleDateString()} at ${infoDate.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`;
                    
                    let html = `
                        <div class="additional-info-entry">
                            <div class="additional-info-meta">
                                <strong>Added by: ${info.added_by_name || 'Student'}</strong> 
                                <span> ${timeString}</span>
                            </div>
                            <div class="additional-info-text">${info.info}</div>
                    `;
                    
                    if (info.attachment) {
                        const fileName = info.attachment.split('/').pop();
                        html += `
                            <div class="additional-info-attachment">
                                <a href="${info.attachment}" target="_blank" class="attachment-pill small-pill">
                                    <i class="fa-solid fa-paperclip"></i>
                                    <span>${fileName}</span>
                                </a>
                            </div>
                        `;
                    }
                    html += `</div>`;
                    addInfoContent.innerHTML += html;
                });
            } else {
                addInfoSection.style.display = 'none';
            }
        } 
    }

    // Form rendering (Student View specific)
    if (addInfoFormSection) {
        if (ticket.status === 'PENDING') {
            addInfoFormSection.style.display = 'block';
            
            const pendingMsgContainer = document.getElementById('pendingMessageContainer');
            if (pendingMsgContainer) pendingMsgContainer.style.display = 'block';
            
            let pendingMsg = "Please provide the requested additional information.";
            if (ticket.resolutions && ticket.resolutions.length > 0) {
                const pendingResolutions = ticket.resolutions.filter(r => r.status === 'PENDING');
                if (pendingResolutions.length > 0) {
                    // Get the most recent pending resolution
                    pendingResolutions.sort((a, b) => new Date(b.resolved_at) - new Date(a.resolved_at));
                    pendingMsg = pendingResolutions[0].feedback;
                }
            }
            const pendingMessageTextEl = document.getElementById('pendingMessageText');
            if (pendingMessageTextEl) pendingMessageTextEl.textContent = pendingMsg;
        } else {
            addInfoFormSection.style.display = 'none';
        }
    }

    // Timeline Rendering
    const timelineContainer = document.getElementById('timelineContainer');
    if (timelineContainer) {
        timelineContainer.innerHTML = '';
        const events = [];

        if (ticket.resolutions) {
            ticket.resolutions.forEach(res => {
                events.push({ type: 'resolution', date: new Date(res.resolved_at), data: res });
            });
        }
        if (ticket.student_feedbacks) {
            ticket.student_feedbacks.forEach(fb => {
                events.push({ type: 'feedback', date: new Date(fb.created_at), data: fb });
            });
        }

        if (events.length === 0) {
            timelineContainer.innerHTML = '<p class="empty-timeline">No feedback recorded yet.</p>';
        } else {
            events.sort((a, b) => a.date - b.date);
            events.reverse().forEach(event => {
                const entryDate = event.date;
                const timeString = `${entryDate.toLocaleDateString()} at ${entryDate.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`;
                const entryEl = document.createElement('div');
                entryEl.className = 'timeline-entry';

                if (event.type === 'resolution') {
                    const res = event.data;
                    entryEl.innerHTML = `
                        <div class="timeline-meta">
                            <strong>Resolved by: ${res.resolved_by || 'System'}</strong> 
                            <span class="timeline-date">${timeString}</span>
                        </div>
                        <div class="timeline-feedback">${res.feedback}</div>
                        <div>
                            <span class="status-badge status-${(res.status || 'open').toLowerCase()}">Status updated to: ${res.status || 'OPEN'}</span>
                        </div>
                    `;
                } else if (event.type === 'feedback') {
                    const fb = event.data;
                    const defaultComment = fb.is_satisfied ? 'Satisfied with resolution.' : 'Needs more help.';
                    entryEl.innerHTML = `
                        <div class="timeline-meta" style="color: #6c757d;">
                            <strong>Feedback from: Student</strong> 
                            <span class="timeline-date">${timeString}</span>
                        </div>
                        <div class="timeline-feedback"><em>${fb.comments || defaultComment}</em></div>
                        <div>
                            <span class="status-badge status-${fb.is_satisfied ? 'closed' : 'reopened'}">Status updated to: ${fb.is_satisfied ? 'CLOSED' : 'REOPENED'}</span>
                        </div>
                    `;
                }
                timelineContainer.appendChild(entryEl);
            });
        }
    }

    // Context-Specific Toggles
    
    // Student Context - Feedback Form
    const feedbackSection = document.getElementById('feedbackSection');
    if (feedbackSection) {
        if (ticket.status === 'RESOLVED') {
            feedbackSection.style.display = 'block';
        } else {
            feedbackSection.style.display = 'none';
        }
    }

    // Staff Context - Action Area
    const actionArea = document.getElementById('staffActionArea');
    if (actionArea) {
        if (ticket.status === 'RESOLVED' || ticket.status === 'CLOSED' || ticket.status === 'REJECTED') {
            actionArea.style.display = 'none';
        } else {
            actionArea.style.display = 'block';
        }
    }
}
