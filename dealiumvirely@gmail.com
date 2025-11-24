<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Dealsby Reservations Super Admin Dashboard</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

:root {
/* Charcoal gray and deep blue theme - matching Dealsby */
--bg-gradient-start: #1a2332;
--bg-gradient-end: #0f1922;
--bg-primary: linear-gradient(180deg, var(--bg-gradient-start) 0%, var(--bg-gradient-end) 100%);
--bg-secondary: rgba(26, 35, 50, 0.8);
--bg-tertiary: rgba(30, 45, 65, 0.7);
--bg-hover: rgba(40, 60, 85, 0.6);
--bg-card: rgba(35, 50, 70, 0.5);
--text-primary: #e4e9f0;
--text-secondary: #a8b5c7;
--text-tertiary: #7a8a9e;
--border-color: rgba(70, 100, 140, 0.2);
--primary: #4a9eff;
--success: #10b981;
--warning: #f59e0b;
--danger: #ef4444;
--info: #6366f1;
--purple: #a855f7;
--cyan: #06b6d4;
--pink: #ec4899;
--spacing-sm: 0.5rem;
--spacing-md: 1rem;
--spacing-lg: 1.5rem;
--radius-md: 12px;
--transition-base: 200ms;
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
}

* {
box-sizing: border-box;
margin: 0;
padding: 0;
}

body {
background: var(--bg-primary);
color: var(--text-primary);
font-size: 14px;
min-height: 100vh;
background-attachment: fixed;
overflow-x: hidden;
}

/* Header */
.admin-header {
background: rgba(15, 25, 38, 0.95);
border-bottom: 1px solid var(--border-color);
padding: 20px 40px;
backdrop-filter: blur(10px);
position: sticky;
top: 0;
z-index: 100;
}

.header-content {
display: flex;
justify-content: space-between;
align-items: center;
max-width: 1800px;
margin: 0 auto;
}

.header-title {
display: flex;
align-items: center;
gap: 15px;
}

.logo {
font-size: 32px;
}

.title-group h1 {
font-size: 24px;
font-weight: 700;
color: var(--text-primary);
margin-bottom: 4px;
}

.title-group p {
font-size: 13px;
color: var(--text-secondary);
}

.header-actions {
display: flex;
gap: 15px;
align-items: center;
}

.time-display {
background: var(--bg-card);
padding: 10px 16px;
border-radius: 8px;
font-size: 13px;
color: var(--text-secondary);
border: 1px solid var(--border-color);
}

.admin-user {
display: flex;
align-items: center;
gap: 12px;
padding: 10px 16px;
background: var(--bg-card);
border-radius: 8px;
border: 1px solid var(--border-color);
}

.admin-avatar {
width: 36px;
height: 36px;
border-radius: 50%;
background: linear-gradient(135deg, var(--primary), var(--purple));
display: flex;
align-items: center;
justify-content: center;
font-weight: 700;
font-size: 14px;
}

/* Main Container */
.dashboard-container {
max-width: 1600px;
margin: 0 auto;
padding: 30px 40px;
}

/* Stats Grid */
.stats-grid {
display: grid;
grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
gap: 20px;
margin-bottom: 30px;
}

.stat-card {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
backdrop-filter: blur(10px);
transition: all var(--transition-base);
position: relative;
overflow: hidden;
cursor: pointer;
}

.stat-card::before {
content: '';
position: absolute;
top: 0;
left: 0;
right: 0;
height: 3px;
background: linear-gradient(90deg, var(--primary), var(--purple));
opacity: 0;
transition: opacity var(--transition-base);
}

.stat-card:hover {
transform: translateY(-4px);
box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
border-color: var(--primary);
}

.stat-card:hover::before {
opacity: 1;
}

.stat-card::after {
content: '🔍';
position: absolute;
top: 20px;
right: 20px;
font-size: 18px;
opacity: 0;
transition: opacity var(--transition-base);
}

.stat-card:hover::after {
opacity: 0.5;
}

.stat-header {
display: flex;
justify-content: space-between;
align-items: flex-start;
margin-bottom: 16px;
}

.stat-icon {
font-size: 28px;
padding: 12px;
background: rgba(74, 158, 255, 0.1);
border-radius: 10px;
display: flex;
align-items: center;
justify-content: center;
}

.stat-trend {
display: flex;
align-items: center;
gap: 6px;
font-size: 13px;
font-weight: 600;
padding: 4px 10px;
border-radius: 6px;
}

.trend-up {
color: var(--success);
background: rgba(16, 185, 129, 0.15);
}

.trend-down {
color: var(--danger);
background: rgba(239, 68, 68, 0.15);
}

.stat-value {
font-size: 36px;
font-weight: 800;
color: var(--text-primary);
margin-bottom: 8px;
line-height: 1;
}

.stat-label {
font-size: 13px;
color: var(--text-secondary);
font-weight: 500;
text-transform: uppercase;
letter-spacing: 0.5px;
}

.stat-sublabel {
font-size: 12px;
color: var(--text-tertiary);
margin-top: 8px;
}

/* Modal Styles */
.modal-overlay {
position: fixed;
top: 0;
left: 0;
right: 0;
bottom: 0;
background: rgba(0, 0, 0, 0.85);
backdrop-filter: blur(8px);
display: flex;
align-items: center;
justify-content: center;
z-index: 10000;
padding: 20px;
animation: fadeIn 0.3s ease-out;
}

.modal-content {
background: linear-gradient(180deg, rgba(26, 35, 50, 0.95), rgba(15, 25, 38, 0.95));
border: 1px solid var(--border-color);
border-radius: 16px;
max-width: 1200px;
width: 100%;
max-height: 90vh;
overflow-y: auto;
padding: 32px;
position: relative;
animation: scaleIn 0.3s ease-out;
box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
}

.modal-header {
display: flex;
justify-content: space-between;
align-items: flex-start;
margin-bottom: 24px;
padding-bottom: 20px;
border-bottom: 1px solid var(--border-color);
}

.modal-title {
font-size: 28px;
font-weight: 800;
color: var(--text-primary);
display: flex;
align-items: center;
gap: 12px;
}

.modal-close {
width: 40px;
height: 40px;
border-radius: 8px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
color: var(--text-secondary);
font-size: 24px;
cursor: pointer;
display: flex;
align-items: center;
justify-content: center;
transition: all var(--transition-base);
}

.modal-close:hover {
background: rgba(255, 255, 255, 0.1);
transform: rotate(90deg);
}

/* Modal Tabs */
.modal-tabs {
display: flex;
gap: 8px;
margin-bottom: 24px;
padding-bottom: 16px;
border-bottom: 2px solid var(--border-color);
flex-wrap: wrap;
}

.modal-tab {
padding: 10px 20px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-secondary);
font-size: 13px;
font-weight: 600;
cursor: pointer;
transition: all var(--transition-base);
white-space: nowrap;
}

.modal-tab:hover {
background: rgba(255, 255, 255, 0.08);
border-color: var(--primary);
color: var(--text-primary);
transform: translateY(-2px);
}

.modal-tab.active {
background: linear-gradient(135deg, var(--primary), var(--purple));
border-color: var(--primary);
color: white;
box-shadow: 0 4px 12px rgba(74, 158, 255, 0.3);
}

.modal-close:hover {
background: var(--danger);
border-color: var(--danger);
color: white;
transform: rotate(90deg);
}

.modal-stats-grid {
display: grid;
grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
gap: 16px;
margin-bottom: 24px;
}

.modal-stat-card {
background: rgba(255, 255, 255, 0.03);
border: 1px solid var(--border-color);
border-radius: 10px;
padding: 20px;
text-align: center;
}

.modal-stat-value {
font-size: 32px;
font-weight: 800;
color: var(--primary);
margin-bottom: 8px;
}

.modal-stat-label {
font-size: 12px;
color: var(--text-secondary);
text-transform: uppercase;
letter-spacing: 0.5px;
}

.modal-stat-change {
font-size: 11px;
margin-top: 6px;
font-weight: 600;
}

.modal-chart-container {
background: rgba(0, 0, 0, 0.2);
border-radius: 12px;
padding: 24px;
margin-bottom: 24px;
}

.modal-section {
margin-bottom: 32px;
}

.modal-section-title {
font-size: 18px;
font-weight: 700;
color: var(--text-primary);
margin-bottom: 16px;
display: flex;
align-items: center;
gap: 10px;
}

/* Chart Section */
.chart-section {
display: grid;
grid-template-columns: 2fr 1fr;
gap: 20px;
margin-bottom: 30px;
}

.chart-card {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
backdrop-filter: blur(10px);
cursor: pointer;
transition: all var(--transition-base);
}

.chart-card:hover {
transform: translateY(-2px);
box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
border-color: var(--primary);
}

.chart-header {
display: flex;
justify-content: space-between;
align-items: center;
margin-bottom: 20px;
}

.chart-title {
font-size: 18px;
font-weight: 700;
color: var(--text-primary);
}

.chart-controls {
display: flex;
gap: 8px;
}

.chart-btn {
padding: 8px 14px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 6px;
color: var(--text-secondary);
font-size: 12px;
font-weight: 600;
cursor: pointer;
transition: all var(--transition-base);
}

.chart-btn.active {
background: var(--primary);
color: white;
border-color: var(--primary);
}

.chart-btn:hover {
background: var(--bg-hover);
border-color: var(--primary);
}

.chart-placeholder {
height: 300px;
background: rgba(0, 0, 0, 0.2);
border-radius: 8px;
display: flex;
align-items: center;
justify-content: center;
position: relative;
overflow: hidden;
}

/* Business Grid */
.content-grid {
display: grid;
grid-template-columns: 1fr 1fr;
gap: 20px;
margin-bottom: 30px;
}

.content-card {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
backdrop-filter: blur(10px);
}

.content-header {
display: flex;
justify-content: space-between;
align-items: center;
margin-bottom: 20px;
}

.content-title {
font-size: 16px;
font-weight: 700;
color: var(--text-primary);
display: flex;
align-items: center;
gap: 10px;
}

.badge {
padding: 4px 10px;
border-radius: 6px;
font-size: 11px;
font-weight: 700;
}

.badge-primary {
background: rgba(74, 158, 255, 0.2);
color: var(--primary);
}

.badge-success {
background: rgba(16, 185, 129, 0.2);
color: var(--success);
}

.badge-warning {
background: rgba(245, 158, 11, 0.2);
color: var(--warning);
}

.badge-danger {
background: rgba(239, 68, 68, 0.2);
color: var(--danger);
}

.badge-info {
background: rgba(99, 102, 241, 0.2);
color: var(--info);
}

/* Business List */
.business-list {
display: flex;
flex-direction: column;
gap: 12px;
max-height: 400px;
overflow-y: auto;
padding-right: 8px;
}

.business-item {
background: rgba(255, 255, 255, 0.02);
border: 1px solid var(--border-color);
border-radius: 8px;
padding: 16px;
display: flex;
justify-content: space-between;
align-items: center;
transition: all var(--transition-base);
cursor: pointer;
}

.business-item:hover {
background: var(--bg-hover);
border-color: var(--primary);
transform: translateX(4px);
}

.business-info {
display: flex;
align-items: center;
gap: 12px;
flex: 1;
}

.business-avatar {
width: 48px;
height: 48px;
border-radius: 10px;
background: linear-gradient(135deg, var(--primary), var(--purple));
display: flex;
align-items: center;
justify-content: center;
font-size: 20px;
font-weight: 700;
}

.business-details h4 {
font-size: 14px;
font-weight: 600;
color: var(--text-primary);
margin-bottom: 4px;
}

.business-details p {
font-size: 12px;
color: var(--text-secondary);
}

.business-stats {
display: flex;
gap: 16px;
text-align: right;
}

.business-stat-item {
display: flex;
flex-direction: column;
}

.business-stat-value {
font-size: 16px;
font-weight: 700;
color: var(--primary);
}

.business-stat-label {
font-size: 10px;
color: var(--text-tertiary);
text-transform: uppercase;
}

/* Template Usage */
.template-grid {
display: grid;
gap: 12px;
}

.template-item {
background: rgba(255, 255, 255, 0.02);
border: 1px solid var(--border-color);
border-radius: 8px;
padding: 16px;
transition: all var(--transition-base);
cursor: pointer;
}

.template-item:hover {
background: var(--bg-hover);
border-color: var(--primary);
transform: translateX(4px);
}

.template-header {
display: flex;
justify-content: space-between;
align-items: center;
margin-bottom: 12px;
}

.template-name {
font-size: 14px;
font-weight: 600;
color: var(--text-primary);
display: flex;
align-items: center;
gap: 8px;
}

.template-count {
font-size: 16px;
font-weight: 700;
color: var(--primary);
}

.usage-bar {
height: 8px;
background: rgba(255, 255, 255, 0.05);
border-radius: 4px;
overflow: hidden;
margin-bottom: 8px;
}

.usage-fill {
height: 100%;
background: linear-gradient(90deg, var(--primary), var(--purple));
border-radius: 4px;
transition: width 0.5s ease;
}

.usage-stats {
display: flex;
justify-content: space-between;
font-size: 11px;
color: var(--text-tertiary);
}

/* Activity Log */
.activity-log {
max-height: 400px;
overflow-y: auto;
display: flex;
flex-direction: column;
gap: 12px;
padding-right: 8px;
}

.activity-item {
background: rgba(255, 255, 255, 0.02);
border-left: 3px solid var(--primary);
border-radius: 6px;
padding: 14px;
display: flex;
gap: 12px;
transition: all var(--transition-base);
}

.activity-item:hover {
background: var(--bg-hover);
transform: translateX(4px);
}

.activity-icon {
font-size: 20px;
width: 36px;
height: 36px;
display: flex;
align-items: center;
justify-content: center;
background: rgba(74, 158, 255, 0.15);
border-radius: 8px;
flex-shrink: 0;
}

.activity-content {
flex: 1;
}

.activity-text {
font-size: 13px;
color: var(--text-primary);
margin-bottom: 4px;
}

.activity-meta {
font-size: 11px;
color: var(--text-tertiary);
display: flex;
gap: 12px;
}

/* Full Width Section */
.full-width-section {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
backdrop-filter: blur(10px);
margin-bottom: 30px;
}

/* Data Table */
.data-table {
width: 100%;
border-collapse: collapse;
}

.data-table thead {
background: rgba(0, 0, 0, 0.2);
}

.data-table th {
padding: 14px 16px;
text-align: left;
font-size: 12px;
font-weight: 700;
color: var(--text-secondary);
text-transform: uppercase;
letter-spacing: 0.5px;
border-bottom: 1px solid var(--border-color);
}

.data-table td {
padding: 14px 16px;
font-size: 13px;
color: var(--text-primary);
border-bottom: 1px solid rgba(70, 100, 140, 0.1);
}

.data-table tbody tr {
transition: all var(--transition-base);
}

.data-table tbody tr:hover {
background: var(--bg-hover);
}

.status-badge {
padding: 6px 12px;
border-radius: 6px;
font-size: 11px;
font-weight: 700;
text-transform: uppercase;
display: inline-block;
}

.status-active {
background: rgba(16, 185, 129, 0.2);
color: var(--success);
}

.status-inactive {
background: rgba(100, 116, 139, 0.2);
color: var(--text-tertiary);
}

.status-trial {
background: rgba(245, 158, 11, 0.2);
color: var(--warning);
}

/* Scrollbar Styling */
::-webkit-scrollbar {
width: 8px;
height: 8px;
}

::-webkit-scrollbar-track {
background: rgba(0, 0, 0, 0.2);
border-radius: 4px;
}

::-webkit-scrollbar-thumb {
background: var(--border-color);
border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
background: var(--primary);
}

/* Animations */
@keyframes fadeIn {
from {
opacity: 0;
}
to {
opacity: 1;
}
}

@keyframes scaleIn {
from {
opacity: 0;
transform: scale(0.9);
}
to {
opacity: 1;
transform: scale(1);
}
}

@keyframes slideIn {
from {
opacity: 0;
transform: translateY(20px);
}
to {
opacity: 1;
transform: translateY(0);
}
}

@keyframes pulse {
0%, 100% {
opacity: 1;
}
50% {
opacity: 0.7;
}
}

.fade-in {
animation: slideIn 0.5s ease-out forwards;
}

/* Chart Canvas */
.chart-canvas {
width: 100%;
height: 300px;
}

/* Responsive */
@media (max-width: 1400px) {
.chart-section {
grid-template-columns: 1fr;
}
}

@media (max-width: 1024px) {
.content-grid {
grid-template-columns: 1fr;
}
.stats-grid {
grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
}
}

@media (max-width: 768px) {
.dashboard-container {
padding: 20px;
}
.admin-header {
padding: 16px 20px;
}
.header-content {
flex-direction: column;
gap: 16px;
}
.stats-grid {
grid-template-columns: 1fr;
}
.modal-content {
padding: 20px;
}
}

/* Quick Action Buttons */
.quick-actions {
display: flex;
gap: 12px;
margin-bottom: 30px;
flex-wrap: wrap;
}

.action-btn {
padding: 12px 20px;
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-primary);
font-size: 13px;
font-weight: 600;
cursor: pointer;
transition: all var(--transition-base);
display: flex;
align-items: center;
gap: 8px;
}

.action-btn:hover {
background: var(--primary);
border-color: var(--primary);
transform: translateY(-2px);
box-shadow: 0 4px 12px rgba(74, 158, 255, 0.3);
}

/* Revenue Chart */
.revenue-breakdown {
display: grid;
grid-template-columns: repeat(4, 1fr);
gap: 16px;
margin-top: 20px;
}

.revenue-item {
background: rgba(255, 255, 255, 0.03);
padding: 16px;
border-radius: 8px;
border: 1px solid var(--border-color);
text-align: center;
}

.revenue-amount {
font-size: 24px;
font-weight: 700;
color: var(--primary);
margin-bottom: 8px;
}

.revenue-label {
font-size: 12px;
color: var(--text-secondary);
text-transform: uppercase;
letter-spacing: 0.5px;
}

/* Comparison Grid */
.comparison-grid {
display: grid;
grid-template-columns: repeat(2, 1fr);
gap: 16px;
margin-top: 20px;
}

.comparison-item {
background: rgba(255, 255, 255, 0.02);
padding: 16px;
border-radius: 8px;
border: 1px solid var(--border-color);
}

.comparison-label {
font-size: 12px;
color: var(--text-secondary);
margin-bottom: 8px;
text-transform: uppercase;
}

.comparison-value {
font-size: 20px;
font-weight: 700;
color: var(--text-primary);
}

/* Detail List */
.detail-list {
display: flex;
flex-direction: column;
gap: 12px;
}

.detail-item {
background: rgba(255, 255, 255, 0.02);
padding: 16px;
border-radius: 8px;
border: 1px solid var(--border-color);
display: flex;
justify-content: space-between;
align-items: center;
}

.detail-item-label {
font-size: 14px;
color: var(--text-secondary);
}

.detail-item-value {
font-size: 16px;
font-weight: 700;
color: var(--primary);
}

/* Progress Ring */
.progress-ring-container {
display: flex;
align-items: center;
justify-content: center;
margin: 20px 0;
}

/* ==================== LEFT SIDEBAR MENU ==================== */
.app-layout {
display: flex;
min-height: calc(100vh - 80px);
}

.left-sidebar {
width: 260px;
background: rgba(15, 25, 38, 0.95);
border-right: 1px solid var(--border-color);
backdrop-filter: blur(10px);
position: sticky;
top: 80px;
height: calc(100vh - 80px);
overflow-y: auto;
flex-shrink: 0;
padding: 20px 0;
transition: all 0.3s ease;
z-index: 50;
}

.left-sidebar::-webkit-scrollbar {
width: 4px;
}

.left-sidebar::-webkit-scrollbar-thumb {
background: var(--border-color);
border-radius: 2px;
}

.sidebar-section {
padding: 0 16px;
margin-bottom: 24px;
}

.sidebar-section-title {
font-size: 10px;
font-weight: 700;
color: var(--text-tertiary);
text-transform: uppercase;
letter-spacing: 1.2px;
padding: 8px 12px;
margin-bottom: 8px;
}

.sidebar-nav {
display: flex;
flex-direction: column;
gap: 4px;
}

.sidebar-link {
display: flex;
align-items: center;
gap: 12px;
padding: 12px 16px;
color: var(--text-secondary);
text-decoration: none;
font-size: 13px;
font-weight: 500;
border-radius: 8px;
transition: all var(--transition-base);
cursor: pointer;
position: relative;
}

.sidebar-link:hover {
background: var(--bg-hover);
color: var(--text-primary);
transform: translateX(4px);
}

.sidebar-link.active {
background: linear-gradient(135deg, rgba(74, 158, 255, 0.2), rgba(168, 85, 247, 0.15));
color: var(--primary);
border-left: 3px solid var(--primary);
margin-left: -3px;
}

.sidebar-link.active::before {
content: '';
position: absolute;
left: 0;
top: 0;
bottom: 0;
width: 3px;
background: linear-gradient(180deg, var(--primary), var(--purple));
border-radius: 0 2px 2px 0;
}

.sidebar-link-icon {
font-size: 18px;
width: 24px;
text-align: center;
flex-shrink: 0;
}

.sidebar-link-text {
flex: 1;
}

.sidebar-link-badge {
background: var(--danger);
color: white;
font-size: 10px;
font-weight: 700;
padding: 2px 6px;
border-radius: 10px;
min-width: 18px;
text-align: center;
}

.sidebar-link-badge.info {
background: var(--primary);
}

.sidebar-link-badge.warning {
background: var(--warning);
}

.sidebar-link-badge.success {
background: var(--success);
}

.sidebar-divider {
height: 1px;
background: var(--border-color);
margin: 16px 16px;
}

/* Sidebar Footer */
.sidebar-footer {
padding: 16px;
margin-top: auto;
border-top: 1px solid var(--border-color);
}

.sidebar-footer-card {
background: linear-gradient(135deg, rgba(74, 158, 255, 0.1), rgba(168, 85, 247, 0.1));
border: 1px solid var(--border-color);
border-radius: 10px;
padding: 16px;
}

.sidebar-footer-title {
font-size: 12px;
font-weight: 700;
color: var(--text-primary);
margin-bottom: 6px;
}

.sidebar-footer-text {
font-size: 11px;
color: var(--text-tertiary);
margin-bottom: 12px;
line-height: 1.4;
}

.sidebar-footer-btn {
width: 100%;
padding: 8px 12px;
background: linear-gradient(135deg, var(--primary), var(--purple));
border: none;
border-radius: 6px;
color: white;
font-size: 11px;
font-weight: 600;
cursor: pointer;
transition: all var(--transition-base);
}

.sidebar-footer-btn:hover {
transform: translateY(-2px);
box-shadow: 0 4px 12px rgba(74, 158, 255, 0.4);
}

/* Main Content Area */
.main-content {
flex: 1;
min-width: 0;
}

/* Content Sections */
.content-section {
display: none;
animation: fadeIn 0.3s ease-out;
}

.content-section.active {
display: block;
}

/* Section Headers */
.section-header {
margin-bottom: 30px;
padding-bottom: 20px;
border-bottom: 1px solid var(--border-color);
}

.section-title {
font-size: 28px;
font-weight: 800;
color: var(--text-primary);
margin-bottom: 8px;
}

.section-subtitle {
font-size: 14px;
color: var(--text-secondary);
}

/* Search and Filter Inputs */
.search-input {
padding: 10px 16px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-primary);
font-size: 13px;
width: 300px;
transition: all var(--transition-base);
}

.search-input:focus {
outline: none;
border-color: var(--primary);
box-shadow: 0 0 0 3px rgba(74, 158, 255, 0.1);
}

.filter-select {
padding: 10px 16px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-primary);
font-size: 13px;
cursor: pointer;
transition: all var(--transition-base);
}

.filter-select:focus {
outline: none;
border-color: var(--primary);
}

/* Settings Styles */
.settings-group {
display: flex;
flex-direction: column;
gap: 16px;
}

.setting-item {
display: flex;
justify-content: space-between;
align-items: center;
padding: 16px;
background: rgba(255, 255, 255, 0.02);
border-radius: 8px;
border: 1px solid var(--border-color);
}

.setting-info {
flex: 1;
}

.setting-name {
font-size: 14px;
font-weight: 600;
color: var(--text-primary);
margin-bottom: 4px;
}

.setting-desc {
font-size: 12px;
color: var(--text-tertiary);
}

/* Toggle Switch */
.toggle-switch {
position: relative;
display: inline-block;
width: 48px;
height: 26px;
}

.toggle-switch input {
opacity: 0;
width: 0;
height: 0;
}

.toggle-slider {
position: absolute;
cursor: pointer;
top: 0;
left: 0;
right: 0;
bottom: 0;
background: rgba(100, 116, 139, 0.4);
border-radius: 26px;
transition: all 0.3s ease;
}

.toggle-slider:before {
position: absolute;
content: "";
height: 20px;
width: 20px;
left: 3px;
bottom: 3px;
background: white;
border-radius: 50%;
transition: all 0.3s ease;
}

.toggle-switch input:checked + .toggle-slider {
background: linear-gradient(135deg, var(--primary), var(--purple));
}

.toggle-switch input:checked + .toggle-slider:before {
transform: translateX(22px);
}

/* Integrations Grid */
.integration-card {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
display: flex;
align-items: center;
gap: 16px;
transition: all var(--transition-base);
cursor: pointer;
}

.integration-card:hover {
transform: translateY(-2px);
border-color: var(--primary);
box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.integration-icon {
font-size: 36px;
width: 60px;
height: 60px;
display: flex;
align-items: center;
justify-content: center;
background: rgba(74, 158, 255, 0.1);
border-radius: 12px;
}

.integration-info {
flex: 1;
}

.integration-name {
font-size: 16px;
font-weight: 700;
color: var(--text-primary);
margin-bottom: 4px;
}

.integration-status {
font-size: 12px;
color: var(--text-tertiary);
}

.integration-badge {
padding: 6px 12px;
border-radius: 20px;
font-size: 11px;
font-weight: 700;
}

.integration-badge.connected {
background: rgba(16, 185, 129, 0.2);
color: var(--success);
}

.integration-badge.available {
background: rgba(74, 158, 255, 0.2);
color: var(--primary);
}

/* Sidebar Toggle for Mobile */
.sidebar-toggle {
display: none;
position: fixed;
bottom: 20px;
left: 20px;
width: 50px;
height: 50px;
background: linear-gradient(135deg, var(--primary), var(--purple));
border: none;
border-radius: 50%;
color: white;
font-size: 24px;
cursor: pointer;
z-index: 1000;
box-shadow: 0 4px 15px rgba(74, 158, 255, 0.4);
transition: all var(--transition-base);
}

.sidebar-toggle:hover {
transform: scale(1.1);
}

/* Responsive Sidebar */
@media (max-width: 1200px) {
.left-sidebar {
width: 220px;
}
}

@media (max-width: 1024px) {
.left-sidebar {
position: fixed;
left: -280px;
top: 0;
height: 100vh;
width: 280px;
z-index: 1000;
padding-top: 20px;
}

.left-sidebar.open {
left: 0;
}

.sidebar-toggle {
display: flex;
align-items: center;
justify-content: center;
}

.sidebar-overlay {
display: none;
position: fixed;
top: 0;
left: 0;
right: 0;
bottom: 0;
background: rgba(0, 0, 0, 0.5);
z-index: 999;
}

.sidebar-overlay.active {
display: block;
}

.main-content {
width: 100%;
}
}

</style>
</head>
<body>

<!-- Header -->
<header class="admin-header">
<div class="header-content">
<div class="header-title">
<div class="logo">🍽️</div>
<div class="title-group">
<h1>Dealsby Reservations Super Admin Dashboard</h1>
<p>Comprehensive Business Intelligence & Analytics Platform</p>
</div>
</div>
<div class="header-actions">
<div class="time-display" id="currentTime">Loading...</div>
<div class="admin-user">
<div class="admin-avatar">VM</div>
<div>
<div style="font-size: 13px; font-weight: 600; color: var(--text-primary);">Virely Management</div>
<div style="font-size: 11px; color: var(--text-tertiary);">Super Admin</div>
</div>
</div>
</div>
</div>
</header>

<!-- Mobile Sidebar Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<!-- App Layout with Sidebar -->
<div class="app-layout">

<!-- Left Sidebar Menu -->
<aside class="left-sidebar" id="leftSidebar">
	<div class="sidebar-section">
		<div class="sidebar-section-title">Main</div>
		<nav class="sidebar-nav">
			<a href="#" class="sidebar-link active" onclick="navigateTo('dashboard', event)">
				<span class="sidebar-link-icon">📊</span>
				<span class="sidebar-link-text">Dashboard</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('businesses', event)">
				<span class="sidebar-link-icon">🏢</span>
				<span class="sidebar-link-text">Businesses</span>
				<span class="sidebar-link-badge info">247</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('reservations', event)">
				<span class="sidebar-link-icon">📅</span>
				<span class="sidebar-link-text">Reservations</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('customers', event)">
				<span class="sidebar-link-icon">👥</span>
				<span class="sidebar-link-text">Customers</span>
			</a>
		</nav>
	</div>
	
	<div class="sidebar-section">
		<div class="sidebar-section-title">Analytics</div>
		<nav class="sidebar-nav">
			<a href="#" class="sidebar-link" onclick="navigateTo('revenue', event)">
				<span class="sidebar-link-icon">💰</span>
				<span class="sidebar-link-text">Revenue & Billing</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('analytics', event)">
				<span class="sidebar-link-icon">📈</span>
				<span class="sidebar-link-text">Analytics</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('reports', event)">
				<span class="sidebar-link-icon">📋</span>
				<span class="sidebar-link-text">Reports</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('markets', event)">
				<span class="sidebar-link-icon">🗺️</span>
				<span class="sidebar-link-text">Geographic Markets</span>
				<span class="sidebar-link-badge success">127</span>
			</a>
		</nav>
	</div>
	
	<div class="sidebar-divider"></div>
	
	<div class="sidebar-section">
		<div class="sidebar-section-title">Management</div>
		<nav class="sidebar-nav">
			<a href="#" class="sidebar-link" onclick="navigateTo('users', event)">
				<span class="sidebar-link-icon">👤</span>
				<span class="sidebar-link-text">Users & Teams</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('templates', event)">
				<span class="sidebar-link-icon">📐</span>
				<span class="sidebar-link-text">Templates</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('marketing', event)">
				<span class="sidebar-link-icon">📣</span>
				<span class="sidebar-link-text">Marketing</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('support', event)">
				<span class="sidebar-link-icon">🎫</span>
				<span class="sidebar-link-text">Support Tickets</span>
				<span class="sidebar-link-badge">8</span>
			</a>
		</nav>
	</div>
	
	<div class="sidebar-section">
		<div class="sidebar-section-title">System</div>
		<nav class="sidebar-nav">
			<a href="#" class="sidebar-link" onclick="navigateTo('integrations', event)">
				<span class="sidebar-link-icon">🔌</span>
				<span class="sidebar-link-text">Integrations</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('system', event)">
				<span class="sidebar-link-icon">⚡</span>
				<span class="sidebar-link-text">System Status</span>
				<span class="sidebar-link-badge success">●</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('settings', event)">
				<span class="sidebar-link-icon">⚙️</span>
				<span class="sidebar-link-text">Settings</span>
			</a>
			<a href="#" class="sidebar-link" onclick="navigateTo('logs', event)">
				<span class="sidebar-link-icon">📜</span>
				<span class="sidebar-link-text">Activity Logs</span>
			</a>
		</nav>
	</div>
	
	<div class="sidebar-footer">
		<div class="sidebar-footer-card">
			<div class="sidebar-footer-title">🚀 Dealsby Reservations</div>
			<div class="sidebar-footer-text">Super Admin Portal v2.0<br>Last sync: Just now</div>
			<button class="sidebar-footer-btn" onclick="showToast('Checking for updates...', 'info')">Check for Updates</button>
		</div>
	</div>
</aside>

<!-- Main Content Area -->
<div class="main-content">

<!-- SECTION: Dashboard -->
<section id="section-dashboard" class="content-section active">
<!-- Main Dashboard -->
<div class="dashboard-container">

<!-- Quick Actions -->
<div class="quick-actions">
<button class="action-btn" onclick="refreshDashboard()">
<span>🔄</span> Refresh Data
</button>
<button class="action-btn" onclick="exportReport()">
<span>📊</span> Export Report
</button>
<button class="action-btn" onclick="viewDetailedAnalytics()">
<span>📈</span> Detailed Analytics
</button>
<button class="action-btn" onclick="manageSubscriptions()">
<span>💳</span> Manage Subscriptions
</button>
<button class="action-btn" onclick="viewGeographicDistribution()">
<span>🌍</span> Geographic View
</button>
</div>

<!-- Key Metrics - CLICKABLE FOR DRILL-DOWN -->
<div class="stats-grid">
<div class="stat-card fade-in" style="animation-delay: 0s" onclick="showBusinessesModal()">
<div class="stat-header">
<div class="stat-icon">🏢</div>
<div class="stat-trend trend-up">
↗ 12.5%
</div>
</div>
<div class="stat-value" id="totalBusinesses">247</div>
<div class="stat-label">Total Businesses Subscribed</div>
<div class="stat-sublabel">+28 new businesses this month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.1s" onclick="showRevenueModal()">
<div class="stat-header">
<div class="stat-icon">💰</div>
<div class="stat-trend trend-up">
↗ 18.3%
</div>
</div>
<div class="stat-value">$124.5K</div>
<div class="stat-label">Monthly Recurring Revenue</div>
<div class="stat-sublabel">+$18.2K from last month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.2s" onclick="showReservationsModal()">
<div class="stat-header">
<div class="stat-icon">📅</div>
<div class="stat-trend trend-up">
↗ 24.7%
</div>
</div>
<div class="stat-value" id="totalReservations">18,432</div>
<div class="stat-label">Total Reservations (This Month)</div>
<div class="stat-sublabel">3,642 today across all businesses</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.3s" onclick="showUptimeModal()">
<div class="stat-header">
<div class="stat-icon">⚡</div>
<div class="stat-trend trend-up">
↗ 8.9%
</div>
</div>
<div class="stat-value">99.8%</div>
<div class="stat-label">Platform Uptime</div>
<div class="stat-sublabel">99.8% availability last 30 days</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.4s" onclick="showUsersModal()">
<div class="stat-header">
<div class="stat-icon">👥</div>
<div class="stat-trend trend-up">
↗ 15.2%
</div>
</div>
<div class="stat-value">43,892</div>
<div class="stat-label">Active End Users</div>
<div class="stat-sublabel">Customers making reservations</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.5s" onclick="showRatingModal()">
<div class="stat-header">
<div class="stat-icon">⭐</div>
<div class="stat-trend trend-up">
↗ 3.2%
</div>
</div>
<div class="stat-value">4.7</div>
<div class="stat-label">Average Rating</div>
<div class="stat-sublabel">From 8,234 customer reviews</div>
</div>

<!-- NEW KPIs -->
<div class="stat-card fade-in" style="animation-delay: 0.6s" onclick="showChurnModal()">
<div class="stat-header">
<div class="stat-icon">📉</div>
<div class="stat-trend trend-down">
↓ 2.1%
</div>
</div>
<div class="stat-value">3.2%</div>
<div class="stat-label">Monthly Churn Rate</div>
<div class="stat-sublabel">8 businesses cancelled this month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.7s" onclick="showNoShowModal()">
<div class="stat-header">
<div class="stat-icon">❌</div>
<div class="stat-trend trend-down">
↓ 5.3%
</div>
</div>
<div class="stat-value">8.4%</div>
<div class="stat-label">No-Show Rate</div>
<div class="stat-sublabel">1,548 no-shows this month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.8s" onclick="showCAC Modal()">
<div class="stat-header">
<div class="stat-icon">💵</div>
<div class="stat-trend trend-down">
↓ 8.7%
</div>
</div>
<div class="stat-value">$342</div>
<div class="stat-label">Customer Acquisition Cost</div>
<div class="stat-sublabel">Down from $375 last month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.9s" onclick="showRetentionModal()">
<div class="stat-header">
<div class="stat-icon">🔁</div>
<div class="stat-trend trend-up">
↗ 6.8%
</div>
</div>
<div class="stat-value">87.3%</div>
<div class="stat-label">Customer Retention Rate</div>
<div class="stat-sublabel">12-month retention metric</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 1s" onclick="showARPUModal()">
<div class="stat-header">
<div class="stat-icon">💳</div>
<div class="stat-trend trend-up">
↗ 11.2%
</div>
</div>
<div class="stat-value">$504</div>
<div class="stat-label">Average Revenue Per User</div>
<div class="stat-sublabel">Per business per month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 1.1s" onclick="showTableTurnoverModal()">
<div class="stat-header">
<div class="stat-icon">🔄</div>
<div class="stat-trend trend-up">
↗ 4.5%
</div>
</div>
<div class="stat-value">3.2x</div>
<div class="stat-label">Average Table Turnover</div>
<div class="stat-sublabel">Per day across all businesses</div>
</div>
</div>

<!-- Additional Business Statistics Panels -->
<div class="content-grid">
<!-- Peak Hours Analysis -->
<div class="content-card fade-in" style="animation-delay: 1.2s">
<div class="content-header">
<div class="content-title">
⏰ Peak Hours Analysis
<span class="badge badge-info">Live Data</span>
</div>
</div>
<div class="template-grid">
<div class="template-item">
<div class="template-header">
<div class="template-name">🌅 Lunch Rush (11AM-2PM)</div>
<div class="template-count" style="color: var(--warning);">6,234</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 75%; background: var(--warning);"></div>
</div>
<div class="usage-stats">
<span>75% capacity</span>
<span>34% of daily traffic</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🌆 Dinner Peak (6PM-9PM)</div>
<div class="template-count" style="color: var(--danger);">8,847</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 95%; background: var(--danger);"></div>
</div>
<div class="usage-stats">
<span>95% capacity</span>
<span>48% of daily traffic</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🌙 Late Night (9PM-Close)</div>
<div class="template-count" style="color: var(--success);">2,189</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 35%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>35% capacity</span>
<span>12% of daily traffic</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">☀️ Off-Peak Hours</div>
<div class="template-count" style="color: var(--cyan);">1,114</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 20%; background: var(--cyan);"></div>
</div>
<div class="usage-stats">
<span>20% capacity</span>
<span>6% of daily traffic</span>
</div>
</div>
</div>
</div>

<!-- Revenue by Plan -->
<div class="content-card fade-in" style="animation-delay: 1.3s">
<div class="content-header">
<div class="content-title">
💎 Revenue by Subscription Plan
<span class="badge badge-success">$124.5K MRR</span>
</div>
</div>
<div class="template-grid">
<div class="template-item" style="cursor: pointer;" onclick="showPlanDetails('enterprise')">
<div class="template-header">
<div class="template-name">🏆 Growth Plan</div>
<div class="template-count" style="color: var(--purple);">$68.4K</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 55%; background: var(--purple);"></div>
</div>
<div class="usage-stats">
<span>55% of MRR</span>
<span>42 businesses @ $199/mo</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showPlanDetails('professional')">
<div class="template-header">
<div class="template-name">💼 Starter Plan</div>
<div class="template-count" style="color: var(--primary);">$38.9K</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 31%; background: var(--primary);"></div>
</div>
<div class="usage-stats">
<span>31% of MRR</span>
<span>89 businesses @ $437/mo</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showPlanDetails('starter')">
<div class="template-header">
<div class="template-name">🚀 Starter Plan</div>
<div class="template-count" style="color: var(--success);">$17.2K</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 14%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>14% of MRR</span>
<span>116 businesses @ $148/mo</span>
</div>
</div>
</div>
</div>
</div>

<!-- Charts Section - CLICKABLE -->
<div class="chart-section">
<div class="chart-card fade-in" style="animation-delay: 1.4s" onclick="showRevenueChartModal()">
<div class="chart-header">
<div class="chart-title">📈 Revenue & Growth Analytics</div>
<div class="chart-controls">
<button class="chart-btn active" onclick="event.stopPropagation(); setChartPeriod('7d')">7D</button>
<button class="chart-btn" onclick="event.stopPropagation(); setChartPeriod('30d')">30D</button>
<button class="chart-btn" onclick="event.stopPropagation(); setChartPeriod('90d')">90D</button>
<button class="chart-btn" onclick="event.stopPropagation(); setChartPeriod('1y')">1Y</button>
</div>
</div>
<canvas id="revenueChart" class="chart-canvas"></canvas>
<div class="revenue-breakdown">
<div class="revenue-item">
<div class="revenue-amount">$124.5K</div>
<div class="revenue-label">This Month</div>
</div>
<div class="revenue-item">
<div class="revenue-amount">$106.3K</div>
<div class="revenue-label">Last Month</div>
</div>
<div class="revenue-item">
<div class="revenue-amount">$1.2M</div>
<div class="revenue-label">YTD Revenue</div>
</div>
<div class="revenue-item">
<div class="revenue-amount">$1.5M</div>
<div class="revenue-label">Projected Annual</div>
</div>
</div>
</div>

<div class="chart-card fade-in" style="animation-delay: 1.5s" onclick="showSubscriptionChartModal()">
<div class="chart-header">
<div class="chart-title">🎯 Business Distribution</div>
</div>
<canvas id="subscriptionChart" class="chart-canvas"></canvas>
</div>
</div>

<!-- Content Grid -->
<div class="content-grid">
<!-- Top Performing Businesses - CLICKABLE -->
<div class="content-card fade-in" style="animation-delay: 1.6s">
<div class="content-header">
<div class="content-title">
🏆 Top Performing Businesses
<span class="badge badge-primary">Live</span>
</div>
</div>
<div class="business-list" id="topBusinesses">
<!-- Populated by JavaScript -->
</div>
</div>

<!-- Template Usage - CLICKABLE -->
<div class="content-card fade-in" style="animation-delay: 1.7s">
<div class="content-header">
<div class="content-title">
📋 Template Utilization
<span class="badge badge-success">8 Templates</span>
</div>
</div>
<div class="template-grid" id="templateUsage">
<!-- Populated by JavaScript -->
</div>
</div>
</div>

<!-- Geographic Distribution -->
<div class="content-grid">
<div class="content-card fade-in" style="animation-delay: 1.8s">
<div class="content-header">
<div class="content-title">
🌍 Geographic Distribution
<span class="badge badge-info">247 Locations</span>
</div>
</div>
<div class="template-grid">
<div class="template-item">
<div class="template-header">
<div class="template-name">🗽 Northeast Region</div>
<div class="template-count" style="color: var(--primary);">87</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 35%; background: var(--primary);"></div>
</div>
<div class="usage-stats">
<span>35% of businesses</span>
<span>$42.8K MRR</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🌴 Southeast Region</div>
<div class="template-count" style="color: var(--success);">64</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 26%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>26% of businesses</span>
<span>$31.2K MRR</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🌊 West Coast</div>
<div class="template-count" style="color: var(--purple);">58</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 23%; background: var(--purple);"></div>
</div>
<div class="usage-stats">
<span>23% of businesses</span>
<span>$29.6K MRR</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🏔️ Midwest Region</div>
<div class="template-count" style="color: var(--warning);">38</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 16%; background: var(--warning);"></div>
</div>
<div class="usage-stats">
<span>16% of businesses</span>
<span>$20.9K MRR</span>
</div>
</div>
</div>
</div>

<!-- Customer Satisfaction Metrics -->
<div class="content-card fade-in" style="animation-delay: 1.9s">
<div class="content-header">
<div class="content-title">
😊 Customer Satisfaction Metrics
<span class="badge badge-success">4.7★ Average</span>
</div>
</div>
<div class="template-grid">
<div class="template-item">
<div class="template-header">
<div class="template-name">⭐⭐⭐⭐⭐ 5 Stars</div>
<div class="template-count" style="color: var(--success);">5,892</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 72%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>72% of reviews</span>
<span>Excellent service</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">⭐⭐⭐⭐ 4 Stars</div>
<div class="template-count" style="color: var(--primary);">1,647</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 20%; background: var(--primary);"></div>
</div>
<div class="usage-stats">
<span>20% of reviews</span>
<span>Good experience</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">⭐⭐⭐ 3 Stars & Below</div>
<div class="template-count" style="color: var(--danger);">695</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 8%; background: var(--danger);"></div>
</div>
<div class="usage-stats">
<span>8% of reviews</span>
<span>Needs improvement</span>
</div>
</div>
</div>
</div>
</div>

<!-- Recent Activity -->
<div class="content-grid">
<div class="content-card fade-in" style="animation-delay: 2s">
<div class="content-header">
<div class="content-title">
⚡ Real-Time Activity Feed
<span class="badge badge-warning" id="activityCount">42 events</span>
</div>
</div>
<div class="activity-log" id="activityFeed">
<!-- Populated by JavaScript -->
</div>
</div>

<!-- System Health -->
<div class="content-card fade-in" style="animation-delay: 2.1s">
<div class="content-header">
<div class="content-title">
💊 System Health & Performance
<span class="badge badge-success">Healthy</span>
</div>
</div>
<div class="template-grid">
<div class="template-item" style="cursor: pointer;" onclick="showSystemHealthModal()">
<div class="template-header">
<div class="template-name">🌐 API Response Time</div>
<div class="template-count" style="color: var(--success);">124ms</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 15%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>Excellent</span>
<span>Target: &lt;200ms</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showSystemHealthModal()">
<div class="template-header">
<div class="template-name">💾 Database Load</div>
<div class="template-count" style="color: var(--warning);">68%</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 68%; background: var(--warning);"></div>
</div>
<div class="usage-stats">
<span>Moderate</span>
<span>Capacity: 32% free</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showSystemHealthModal()">
<div class="template-header">
<div class="template-name">🚀 Server Uptime</div>
<div class="template-count" style="color: var(--success);">99.8%</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 99.8%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>Excellent (28d 4h 32m)</span>
<span>Last incident: 14 days ago</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showSystemHealthModal()">
<div class="template-header">
<div class="template-name">📊 Active Sessions</div>
<div class="template-count" style="color: var(--primary);">2,847</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 45%; background: var(--primary);"></div>
</div>
<div class="usage-stats">
<span>Normal load</span>
<span>Peak capacity: 6,000</span>
</div>
</div>
</div>
</div>
</div>

<!-- Detailed Subscription Table -->
<div class="full-width-section fade-in" style="animation-delay: 2.2s">
<div class="content-header" style="margin-bottom: 20px;">
<div class="content-title" style="font-size: 18px;">
📊 All Business Subscriptions
</div>
<div style="display: flex; gap: 12px;">
<input type="text" id="searchBusinesses" placeholder="Search businesses..." style="
padding: 10px 16px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-primary);
font-size: 13px;
width: 300px;
" />
<select id="filterStatus" style="
padding: 10px 16px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-primary);
font-size: 13px;
cursor: pointer;
">
<option value="all">All Status</option>
<option value="active">Active</option>
<option value="trial">Trial</option>
<option value="inactive">Inactive</option>
</select>
</div>
</div>
<div style="overflow-x: auto;">
<table class="data-table">
<thead>
<tr>
<th>Business Name</th>
<th>Owner</th>
<th>Plan</th>
<th>Status</th>
<th>Template</th>
<th>Reservations (30d)</th>
<th>Revenue</th>
<th>Join Date</th>
<th>Actions</th>
</tr>
</thead>
<tbody id="businessTable">
<!-- Populated by JavaScript -->
</tbody>
</table>
</div>
</div>

</div>
</section><!-- End Dashboard Section -->

<!-- SECTION: Businesses -->
<section id="section-businesses" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">🏢 Businesses Management</h2>
		<p class="section-subtitle">Manage all subscribed businesses, view details, and handle subscriptions</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🏢</div>
				<div class="stat-trend trend-up">↗ 12.5%</div>
			</div>
			<div class="stat-value">247</div>
			<div class="stat-label">Total Businesses</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">✅</div>
			</div>
			<div class="stat-value">198</div>
			<div class="stat-label">Active Subscriptions</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⏳</div>
			</div>
			<div class="stat-value">34</div>
			<div class="stat-label">On Trial</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⚠️</div>
			</div>
			<div class="stat-value">15</div>
			<div class="stat-label">Churned (30d)</div>
		</div>
	</div>
	
	<div class="quick-actions" style="margin-bottom: 20px;">
		<button class="action-btn" onclick="showAddBusinessModal()">
			<span>➕</span> Add Business
		</button>
		<button class="action-btn" onclick="exportBusinesses()">
			<span>📥</span> Export CSV
		</button>
		<button class="action-btn" onclick="bulkActions()">
			<span>⚡</span> Bulk Actions
		</button>
	</div>
	
	<div class="full-width-section">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">All Businesses</div>
			<div style="display: flex; gap: 12px;">
				<input type="text" id="searchBusinessesSection" placeholder="Search businesses..." class="search-input" onkeyup="filterBusinessesSection(this.value)" />
				<select id="filterPlan" class="filter-select" onchange="filterByPlan(this.value)">
					<option value="all">All Plans</option>
					<option value="Starter">Starter</option>
					<option value="Growth">Growth</option>
				</select>
			</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table" id="businessesTable">
				<thead>
					<tr>
						<th>Business Name</th>
						<th>Owner</th>
						<th>Plan</th>
						<th>Status</th>
						<th>Template</th>
						<th>Reservations</th>
						<th>MRR</th>
						<th>Join Date</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody id="businessTableSection"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Reservations -->
<section id="section-reservations" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">📅 Reservations Overview</h2>
		<p class="section-subtitle">Monitor all reservations across the platform in real-time</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📅</div>
				<div class="stat-trend trend-up">↗ 24.7%</div>
			</div>
			<div class="stat-value">18,432</div>
			<div class="stat-label">This Month</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📆</div>
			</div>
			<div class="stat-value">3,642</div>
			<div class="stat-label">Today</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">✅</div>
			</div>
			<div class="stat-value">94.2%</div>
			<div class="stat-label">Show Rate</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⏱️</div>
			</div>
			<div class="stat-value">2.4</div>
			<div class="stat-label">Avg Party Size</div>
		</div>
	</div>
	
	<div class="chart-section">
		<div class="chart-card">
			<div class="chart-header">
				<div class="chart-title">📊 Reservation Trends</div>
				<div class="chart-controls">
					<button class="chart-btn active" onclick="setReservationPeriod('7d')">7D</button>
					<button class="chart-btn" onclick="setReservationPeriod('30d')">30D</button>
					<button class="chart-btn" onclick="setReservationPeriod('90d')">90D</button>
				</div>
			</div>
			<canvas id="reservationTrendsChart" class="chart-canvas"></canvas>
		</div>
		<div class="chart-card">
			<div class="chart-header">
				<div class="chart-title">⏰ Peak Hours Distribution</div>
			</div>
			<canvas id="peakHoursChart" class="chart-canvas"></canvas>
		</div>
	</div>
	
	<div class="full-width-section">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">Recent Reservations</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Reservation ID</th>
						<th>Business</th>
						<th>Customer</th>
						<th>Date & Time</th>
						<th>Party Size</th>
						<th>Status</th>
						<th>Source</th>
					</tr>
				</thead>
				<tbody id="reservationsTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Customers -->
<section id="section-customers" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">👥 Customer Database</h2>
		<p class="section-subtitle">View and manage customers across all businesses</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">👥</div>
				<div class="stat-trend trend-up">↗ 18.2%</div>
			</div>
			<div class="stat-value">156,842</div>
			<div class="stat-label">Total Customers</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🆕</div>
			</div>
			<div class="stat-value">8,423</div>
			<div class="stat-label">New This Month</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🔄</div>
			</div>
			<div class="stat-value">67.3%</div>
			<div class="stat-label">Return Rate</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⭐</div>
			</div>
			<div class="stat-value">4.7</div>
			<div class="stat-label">Avg Satisfaction</div>
		</div>
	</div>
	
	<div class="full-width-section">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">Customer Records</div>
			<div style="display: flex; gap: 12px;">
				<input type="text" placeholder="Search customers..." class="search-input" onkeyup="filterCustomers(this.value)" />
			</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Customer</th>
						<th>Email</th>
						<th>Phone</th>
						<th>Total Visits</th>
						<th>Last Visit</th>
						<th>Favorite Business</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody id="customersTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Revenue -->
<section id="section-revenue" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">💰 Revenue & Billing</h2>
		<p class="section-subtitle">Financial overview, billing management, and revenue analytics</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">💰</div>
				<div class="stat-trend trend-up">↗ 18.3%</div>
			</div>
			<div class="stat-value">$124.5K</div>
			<div class="stat-label">Monthly Recurring Revenue</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📈</div>
			</div>
			<div class="stat-value">$1.49M</div>
			<div class="stat-label">Annual Run Rate</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">💵</div>
			</div>
			<div class="stat-value">$504</div>
			<div class="stat-label">Avg Revenue Per User</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📊</div>
			</div>
			<div class="stat-value">94.7%</div>
			<div class="stat-label">Collection Rate</div>
		</div>
	</div>
	
	<div class="chart-section">
		<div class="chart-card">
			<div class="chart-header">
				<div class="chart-title">💵 Revenue Growth</div>
			</div>
			<canvas id="revenueGrowthChart" class="chart-canvas"></canvas>
			<div class="revenue-breakdown">
				<div class="revenue-item">
					<div class="revenue-amount">$89.5K</div>
					<div class="revenue-label">Growth Plan</div>
				</div>
				<div class="revenue-item">
					<div class="revenue-amount">$35.0K</div>
					<div class="revenue-label">Starter Plan</div>
				</div>
				<div class="revenue-item">
					<div class="revenue-amount">$14.5K</div>
					<div class="revenue-label">Starter</div>
				</div>
				<div class="revenue-item">
					<div class="revenue-amount">$0</div>
					<div class="revenue-label">Trial (34)</div>
				</div>
			</div>
		</div>
		<div class="chart-card">
			<div class="chart-header">
				<div class="chart-title">📊 Revenue by Plan</div>
			</div>
			<canvas id="revenuePlanChart" class="chart-canvas"></canvas>
		</div>
	</div>
	
	<div class="full-width-section">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">Recent Transactions</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Transaction ID</th>
						<th>Business</th>
						<th>Amount</th>
						<th>Type</th>
						<th>Status</th>
						<th>Date</th>
						<th>Method</th>
					</tr>
				</thead>
				<tbody id="transactionsTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Analytics -->
<section id="section-analytics" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">📈 Analytics Center</h2>
		<p class="section-subtitle">Deep dive into platform performance metrics and insights</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📊</div>
			</div>
			<div class="stat-value">2.4M</div>
			<div class="stat-label">Total Page Views</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⏱️</div>
			</div>
			<div class="stat-value">4:32</div>
			<div class="stat-label">Avg Session Duration</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🔄</div>
			</div>
			<div class="stat-value">23.4%</div>
			<div class="stat-label">Bounce Rate</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📱</div>
			</div>
			<div class="stat-value">62%</div>
			<div class="stat-label">Mobile Users</div>
		</div>
	</div>
	
	<div class="chart-section">
		<div class="chart-card">
			<div class="chart-header">
				<div class="chart-title">📈 User Engagement</div>
			</div>
			<canvas id="engagementChart" class="chart-canvas"></canvas>
		</div>
		<div class="chart-card">
			<div class="chart-header">
				<div class="chart-title">🌐 Traffic Sources</div>
			</div>
			<canvas id="trafficSourcesChart" class="chart-canvas"></canvas>
		</div>
	</div>
	
	<div class="content-grid">
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">🔥 Top Features Used</div>
			</div>
			<div class="detail-list" id="topFeaturesList"></div>
		</div>
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">📱 Device Breakdown</div>
			</div>
			<div class="detail-list" id="deviceBreakdownList"></div>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Reports -->
<section id="section-reports" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">📋 Reports Generator</h2>
		<p class="section-subtitle">Generate custom reports and export data</p>
	</div>
	
	<div class="quick-actions" style="margin-bottom: 30px;">
		<button class="action-btn" onclick="generateReport('revenue')">
			<span>💰</span> Revenue Report
		</button>
		<button class="action-btn" onclick="generateReport('businesses')">
			<span>🏢</span> Business Report
		</button>
		<button class="action-btn" onclick="generateReport('reservations')">
			<span>📅</span> Reservations Report
		</button>
		<button class="action-btn" onclick="generateReport('custom')">
			<span>⚙️</span> Custom Report
		</button>
	</div>
	
	<div class="content-grid">
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">📊 Recent Reports</div>
			</div>
			<div class="detail-list" id="recentReportsList"></div>
		</div>
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">⏰ Scheduled Reports</div>
			</div>
			<div class="detail-list" id="scheduledReportsList"></div>
		</div>
	</div>
	
	<div class="full-width-section" style="margin-top: 30px;">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">📁 Report History</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Report Name</th>
						<th>Type</th>
						<th>Date Range</th>
						<th>Generated</th>
						<th>Size</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody id="reportHistoryTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Markets -->
<section id="section-markets" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">🗺️ Geographic Markets</h2>
		<p class="section-subtitle">Analyze performance across different geographic regions</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🗺️</div>
			</div>
			<div class="stat-value">127</div>
			<div class="stat-label">Active Markets</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🌆</div>
			</div>
			<div class="stat-value">42</div>
			<div class="stat-label">Major Cities</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📈</div>
			</div>
			<div class="stat-value">+23</div>
			<div class="stat-label">New Markets (YTD)</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🎯</div>
			</div>
			<div class="stat-value">87%</div>
			<div class="stat-label">Market Coverage</div>
		</div>
	</div>
	
	<div class="content-grid">
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">🗽 Top Markets by Revenue</div>
			</div>
			<div class="detail-list" id="topMarketsList"></div>
		</div>
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">🚀 Fastest Growing Markets</div>
			</div>
			<div class="detail-list" id="growingMarketsList"></div>
		</div>
	</div>
	
	<div class="full-width-section" style="margin-top: 30px;">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">🌍 All Markets</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Market</th>
						<th>Region</th>
						<th>Businesses</th>
						<th>MRR</th>
						<th>Growth</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody id="marketsTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Users -->
<section id="section-users" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">👤 Users & Teams</h2>
		<p class="section-subtitle">Manage admin users, team members, and permissions</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">👤</div>
			</div>
			<div class="stat-value">1,247</div>
			<div class="stat-label">Total Users</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">👑</div>
			</div>
			<div class="stat-value">12</div>
			<div class="stat-label">Admin Users</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">👥</div>
			</div>
			<div class="stat-value">847</div>
			<div class="stat-label">Active Today</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🆕</div>
			</div>
			<div class="stat-value">156</div>
			<div class="stat-label">New This Month</div>
		</div>
	</div>
	
	<div class="quick-actions" style="margin-bottom: 20px;">
		<button class="action-btn" onclick="showAddUserModal()">
			<span>➕</span> Add User
		</button>
		<button class="action-btn" onclick="showInviteModal()">
			<span>📧</span> Send Invite
		</button>
		<button class="action-btn" onclick="manageRoles()">
			<span>🔐</span> Manage Roles
		</button>
	</div>
	
	<div class="full-width-section">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">All Users</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>User</th>
						<th>Email</th>
						<th>Role</th>
						<th>Business</th>
						<th>Last Active</th>
						<th>Status</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody id="usersTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Templates -->
<section id="section-templates" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">📐 Template Library</h2>
		<p class="section-subtitle">Manage industry templates and customization options</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📐</div>
			</div>
			<div class="stat-value">8</div>
			<div class="stat-label">Active Templates</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🍽️</div>
			</div>
			<div class="stat-value">142</div>
			<div class="stat-label">Restaurant Users</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">💈</div>
			</div>
			<div class="stat-value">48</div>
			<div class="stat-label">Salon Users</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🏥</div>
			</div>
			<div class="stat-value">32</div>
			<div class="stat-label">Medical Users</div>
		</div>
	</div>
	
	<div class="template-grid" id="templatesGrid" style="margin-bottom: 30px;"></div>
</div>
</section>

<!-- SECTION: Marketing -->
<section id="section-marketing" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">📣 Marketing Hub</h2>
		<p class="section-subtitle">Campaigns, promotions, and growth initiatives</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📧</div>
			</div>
			<div class="stat-value">12</div>
			<div class="stat-label">Active Campaigns</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📨</div>
			</div>
			<div class="stat-value">45.2K</div>
			<div class="stat-label">Emails Sent</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">👆</div>
			</div>
			<div class="stat-value">32.4%</div>
			<div class="stat-label">Open Rate</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🎯</div>
			</div>
			<div class="stat-value">4.8%</div>
			<div class="stat-label">Conversion Rate</div>
		</div>
	</div>
	
	<div class="quick-actions" style="margin-bottom: 20px;">
		<button class="action-btn" onclick="createCampaign()">
			<span>➕</span> New Campaign
		</button>
		<button class="action-btn" onclick="emailBuilder()">
			<span>📧</span> Email Builder
		</button>
		<button class="action-btn" onclick="audienceManager()">
			<span>👥</span> Audiences
		</button>
	</div>
	
	<div class="full-width-section">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">Active Campaigns</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Campaign</th>
						<th>Type</th>
						<th>Audience</th>
						<th>Sent</th>
						<th>Opens</th>
						<th>Clicks</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody id="campaignsTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Support -->
<section id="section-support" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">🎫 Support Tickets</h2>
		<p class="section-subtitle">Manage customer support requests and issues</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🎫</div>
			</div>
			<div class="stat-value">8</div>
			<div class="stat-label">Open Tickets</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⏱️</div>
			</div>
			<div class="stat-value">2.4h</div>
			<div class="stat-label">Avg Response Time</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">✅</div>
			</div>
			<div class="stat-value">147</div>
			<div class="stat-label">Resolved This Month</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⭐</div>
			</div>
			<div class="stat-value">4.8</div>
			<div class="stat-label">Satisfaction Score</div>
		</div>
	</div>
	
	<div class="full-width-section">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">Support Queue</div>
			<div style="display: flex; gap: 12px;">
				<select class="filter-select" onchange="filterTickets(this.value)">
					<option value="all">All Tickets</option>
					<option value="open">Open</option>
					<option value="pending">Pending</option>
					<option value="resolved">Resolved</option>
				</select>
			</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Ticket ID</th>
						<th>Subject</th>
						<th>Business</th>
						<th>Priority</th>
						<th>Created</th>
						<th>Status</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody id="ticketsTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Integrations -->
<section id="section-integrations" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">🔌 Integrations</h2>
		<p class="section-subtitle">Manage third-party integrations and API connections</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🔌</div>
			</div>
			<div class="stat-value">12</div>
			<div class="stat-label">Active Integrations</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📡</div>
			</div>
			<div class="stat-value">1.2M</div>
			<div class="stat-label">API Calls (30d)</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">✅</div>
			</div>
			<div class="stat-value">99.8%</div>
			<div class="stat-label">Success Rate</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">🔑</div>
			</div>
			<div class="stat-value">247</div>
			<div class="stat-label">API Keys Active</div>
		</div>
	</div>
	
	<div class="content-grid" id="integrationsGrid"></div>
</div>
</section>

<!-- SECTION: System -->
<section id="section-system" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">⚡ System Status</h2>
		<p class="section-subtitle">Monitor system health, performance, and uptime</p>
	</div>
	
	<div class="stats-grid" style="margin-bottom: 30px;">
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon" style="background: rgba(16, 185, 129, 0.2);">✅</div>
			</div>
			<div class="stat-value" style="color: var(--success);">Operational</div>
			<div class="stat-label">System Status</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⏱️</div>
			</div>
			<div class="stat-value">99.97%</div>
			<div class="stat-label">Uptime (30d)</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">⚡</div>
			</div>
			<div class="stat-value">142ms</div>
			<div class="stat-label">Avg Response Time</div>
		</div>
		<div class="stat-card">
			<div class="stat-header">
				<div class="stat-icon">📊</div>
			</div>
			<div class="stat-value">2,847</div>
			<div class="stat-label">Active Sessions</div>
		</div>
	</div>
	
	<div class="content-grid">
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">🖥️ Server Status</div>
			</div>
			<div class="detail-list" id="serverStatusList"></div>
		</div>
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">📊 Resource Usage</div>
			</div>
			<div class="detail-list" id="resourceUsageList"></div>
		</div>
	</div>
	
	<div class="full-width-section" style="margin-top: 30px;">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">⚠️ Recent Incidents</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Incident ID</th>
						<th>Type</th>
						<th>Description</th>
						<th>Duration</th>
						<th>Impact</th>
						<th>Status</th>
						<th>Date</th>
					</tr>
				</thead>
				<tbody id="incidentsTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Settings -->
<section id="section-settings" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">⚙️ Settings</h2>
		<p class="section-subtitle">Configure platform settings and preferences</p>
	</div>
	
	<div class="content-grid">
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">🔒 Security Settings</div>
			</div>
			<div class="settings-group">
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Two-Factor Authentication</div>
						<div class="setting-desc">Require 2FA for all admin accounts</div>
					</div>
					<label class="toggle-switch">
						<input type="checkbox" checked>
						<span class="toggle-slider"></span>
					</label>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Session Timeout</div>
						<div class="setting-desc">Auto-logout after inactivity</div>
					</div>
					<select class="filter-select" style="width: auto;">
						<option>30 minutes</option>
						<option selected>1 hour</option>
						<option>4 hours</option>
						<option>Never</option>
					</select>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">IP Whitelist</div>
						<div class="setting-desc">Restrict access by IP address</div>
					</div>
					<label class="toggle-switch">
						<input type="checkbox">
						<span class="toggle-slider"></span>
					</label>
				</div>
			</div>
		</div>
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">📧 Notification Settings</div>
			</div>
			<div class="settings-group">
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Email Notifications</div>
						<div class="setting-desc">Receive alerts via email</div>
					</div>
					<label class="toggle-switch">
						<input type="checkbox" checked>
						<span class="toggle-slider"></span>
					</label>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Slack Integration</div>
						<div class="setting-desc">Send notifications to Slack</div>
					</div>
					<label class="toggle-switch">
						<input type="checkbox" checked>
						<span class="toggle-slider"></span>
					</label>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Daily Digest</div>
						<div class="setting-desc">Receive daily summary emails</div>
					</div>
					<label class="toggle-switch">
						<input type="checkbox">
						<span class="toggle-slider"></span>
					</label>
				</div>
			</div>
		</div>
	</div>
	
	<div class="content-grid" style="margin-top: 30px;">
		<div class="content-card" style="grid-column: span 2;">
			<div class="content-header">
				<div class="content-title">🎨 Branding & Color Palette</div>
			</div>
			<div class="settings-group">
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Platform Name</div>
						<div class="setting-desc">Dealsby Reservations</div>
					</div>
					<button class="action-btn" style="padding: 8px 16px;" onclick="editPlatformName()">Edit</button>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Logo</div>
						<div class="setting-desc">Upload your brand logo (SVG, PNG)</div>
					</div>
					<button class="action-btn" style="padding: 8px 16px;" onclick="uploadLogo()">Upload</button>
				</div>
			</div>
			<div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border-color);">
				<div style="font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 16px;">🎨 Primary Colors</div>
				<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px;">
					<div class="color-swatch" onclick="copyColor('#4a9eff')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 60px; background: #4a9eff;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Primary Blue</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#4a9eff</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#a855f7')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 60px; background: #a855f7;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Purple</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#a855f7</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#10b981')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 60px; background: #10b981;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Success Green</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#10b981</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#f59e0b')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 60px; background: #f59e0b;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Warning Orange</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#f59e0b</div>
						</div>
					</div>
				</div>
				<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-top: 12px;">
					<div class="color-swatch" onclick="copyColor('#ef4444')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 60px; background: #ef4444;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Danger Red</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#ef4444</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#6366f1')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 60px; background: #6366f1;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Info Indigo</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#6366f1</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#06b6d4')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 60px; background: #06b6d4;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Cyan</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#06b6d4</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#ec4899')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 60px; background: #ec4899;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Pink</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#ec4899</div>
						</div>
					</div>
				</div>
			</div>
			<div style="margin-top: 20px;">
				<div style="font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 16px;">🌙 Background Colors</div>
				<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px;">
					<div class="color-swatch" onclick="copyColor('#1a2332')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 50px; background: #1a2332;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">BG Gradient Start</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#1a2332</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#0f1922')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 50px; background: #0f1922;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">BG Gradient End</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#0f1922</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#233246')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 50px; background: #233246;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Card Background</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#233246</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#46648c')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 50px; background: rgba(70, 100, 140, 0.3);"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Border Color</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">rgba(70,100,140,0.2)</div>
						</div>
					</div>
				</div>
			</div>
			<div style="margin-top: 20px;">
				<div style="font-size: 14px; font-weight: 700; color: var(--text-primary); margin-bottom: 16px;">📝 Text Colors</div>
				<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
					<div class="color-swatch" onclick="copyColor('#e4e9f0')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 40px; background: #e4e9f0;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Text Primary</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#e4e9f0</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#a8b5c7')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 40px; background: #a8b5c7;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Text Secondary</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#a8b5c7</div>
						</div>
					</div>
					<div class="color-swatch" onclick="copyColor('#7a8a9e')" style="cursor: pointer; border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; transition: all 0.2s;" title="Click to copy">
						<div style="width: 100%; height: 40px; background: #7a8a9e;"></div>
						<div style="padding: 10px; background: rgba(255,255,255,0.03); text-align: center;">
							<div style="font-size: 12px; font-weight: 600; color: var(--text-primary);">Text Tertiary</div>
							<div style="font-size: 11px; color: var(--text-tertiary); font-family: monospace;">#7a8a9e</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="content-grid" style="margin-top: 30px;">
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">💾 Data Management</div>
			</div>
			<div class="settings-group">
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Data Retention</div>
						<div class="setting-desc">How long to keep historical data</div>
					</div>
					<select class="filter-select" style="width: auto;">
						<option>1 year</option>
						<option selected>2 years</option>
						<option>5 years</option>
						<option>Forever</option>
					</select>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Automatic Backups</div>
						<div class="setting-desc">Daily database backups</div>
					</div>
					<label class="toggle-switch">
						<input type="checkbox" checked>
						<span class="toggle-slider"></span>
					</label>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Export All Data</div>
						<div class="setting-desc">Download complete data archive</div>
					</div>
					<button class="action-btn" style="padding: 8px 16px;" onclick="exportAllData()">Export</button>
				</div>
			</div>
		</div>
		<div class="content-card">
			<div class="content-header">
				<div class="content-title">🔧 API Configuration</div>
			</div>
			<div class="settings-group">
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">API Rate Limiting</div>
						<div class="setting-desc">Max 1000 requests per minute</div>
					</div>
					<select class="filter-select" style="width: auto;">
						<option>500/min</option>
						<option selected>1000/min</option>
						<option>5000/min</option>
						<option>Unlimited</option>
					</select>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">Webhook Retries</div>
						<div class="setting-desc">Retry failed webhook deliveries</div>
					</div>
					<label class="toggle-switch">
						<input type="checkbox" checked>
						<span class="toggle-slider"></span>
					</label>
				</div>
				<div class="setting-item">
					<div class="setting-info">
						<div class="setting-name">API Documentation</div>
						<div class="setting-desc">View developer documentation</div>
					</div>
					<button class="action-btn" style="padding: 8px 16px;" onclick="viewAPIDocs()">View Docs</button>
				</div>
			</div>
		</div>
	</div>
</div>
</section>

<!-- SECTION: Logs -->
<section id="section-logs" class="content-section">
<div class="dashboard-container">
	<div class="section-header">
		<h2 class="section-title">📜 Activity Logs</h2>
		<p class="section-subtitle">Track all platform activity and audit trail</p>
	</div>
	
	<div class="quick-actions" style="margin-bottom: 20px;">
		<button class="action-btn" onclick="exportLogs()">
			<span>📥</span> Export Logs
		</button>
		<button class="action-btn" onclick="filterLogs('today')">
			<span>📅</span> Today
		</button>
		<button class="action-btn" onclick="filterLogs('week')">
			<span>📆</span> This Week
		</button>
		<button class="action-btn" onclick="filterLogs('month')">
			<span>🗓️</span> This Month
		</button>
	</div>
	
	<div class="full-width-section">
		<div class="content-header" style="margin-bottom: 20px;">
			<div class="content-title">Activity Feed</div>
			<div style="display: flex; gap: 12px;">
				<input type="text" placeholder="Search logs..." class="search-input" />
				<select class="filter-select">
					<option value="all">All Events</option>
					<option value="user">User Actions</option>
					<option value="system">System Events</option>
					<option value="billing">Billing</option>
					<option value="security">Security</option>
				</select>
			</div>
		</div>
		<div style="overflow-x: auto;">
			<table class="data-table">
				<thead>
					<tr>
						<th>Timestamp</th>
						<th>Event</th>
						<th>User</th>
						<th>Details</th>
						<th>IP Address</th>
						<th>Type</th>
					</tr>
				</thead>
				<tbody id="logsTableBody"></tbody>
			</table>
		</div>
	</div>
</div>
</section>

<!-- Modal Container -->
<div id="modalContainer"></div>

<script>
// ==================== STATE MANAGEMENT ====================
const dashboardState = {
businesses: [],
templates: [],
activities: [],
metrics: {},
chartPeriod: '7d'
};

// ==================== INITIALIZE DASHBOARD ====================
function initializeDashboard() {
updateTime();
setInterval(updateTime, 1000);
generateMockData();
renderTopBusinesses();
renderTemplateUsage();
renderActivityFeed();
renderBusinessTable();
initializeCharts();
startRealtimeUpdates();
}

// ==================== TIME DISPLAY ====================
function updateTime() {
const now = new Date();
const options = {
weekday: 'long',
year: 'numeric',
month: 'long',
day: 'numeric',
hour: '2-digit',
minute: '2-digit',
second: '2-digit'
};
document.getElementById('currentTime').textContent = now.toLocaleDateString('en-US', options);
}

// ==================== MOCK DATA GENERATION ====================
function generateMockData() {
// Generate business data
const businessNames = [
'The Golden Spoon Restaurant',
'Bella Vista Trattoria',
'Sakura Japanese Cuisine',
'Le Petit Bistro',
'Ocean Breeze Seafood',
'Mountain View Lodge',
'Urban Grille & Bar',
'Sunset Terrace Dining',
'The Cozy Corner Cafe',
'Majestic Palace Restaurant',
'Riverside Grill House',
'The Artisan Kitchen',
'Harmony Fusion Restaurant',
'The Velvet Room',
'Coastal Catch Seafood',
'Pine Ridge Steakhouse',
'The Garden Bistro',
'Silver Oak Restaurant',
'Metropolitan Dining',
'The Heritage Table'
];

const owners = [
'John Smith', 'Maria Garcia', 'David Chen', 'Sarah Johnson',
'Michael Brown', 'Emily Davis', 'James Wilson', 'Lisa Anderson',
'Robert Taylor', 'Jennifer Martinez', 'William Thomas', 'Jessica Lee',
'Christopher White', 'Amanda Harris', 'Daniel Martin', 'Michelle Thompson',
'Matthew Garcia', 'Ashley Rodriguez', 'Joseph Lewis', 'Stephanie Walker'
];

const plans = ['Starter', 'Growth', 'Starter', 'Growth'];
const statuses = ['active', 'trial', 'active', 'active', 'inactive'];
const templates = [
'Restaurant Classic',
'Modern Minimalist',
'Fine Dining Elegant',
'Casual Eatery',
'Bar & Lounge',
'Quick Service',
'Family Style',
'Upscale Contemporary'
];

dashboardState.businesses = businessNames.map((name, index) => ({
id: index + 1,
name,
owner: owners[index % owners.length],
plan: plans[Math.floor(Math.random() * plans.length)],
status: statuses[Math.floor(Math.random() * statuses.length)],
template: templates[Math.floor(Math.random() * templates.length)],
reservations: Math.floor(Math.random() * 500) + 50,
revenue: (Math.random() * 5000 + 500).toFixed(2),
joinDate: new Date(2024, Math.floor(Math.random() * 10), Math.floor(Math.random() * 28) + 1).toLocaleDateString(),
rating: (Math.random() * 1.5 + 3.5).toFixed(1),
activeUsers: Math.floor(Math.random() * 1000) + 100,
noShowRate: (Math.random() * 15 + 2).toFixed(1),
avgTableTurnover: (Math.random() * 2 + 2).toFixed(1)
}));

// Sort by reservations for top performers
dashboardState.businesses.sort((a, b) => b.reservations - a.reservations);

// Generate template usage data
const templateCounts = {};
dashboardState.businesses.forEach(business => {
templateCounts[business.template] = (templateCounts[business.template] || 0) + 1;
});

dashboardState.templates = Object.entries(templateCounts).map(([name, count]) => ({
name,
count,
percentage: (count / dashboardState.businesses.length * 100).toFixed(1)
}));

// Generate activity data
generateActivityFeed();
}

// ==================== ACTIVITY FEED ====================
function generateActivityFeed() {
const activityTypes = [
{ icon: '🏢', text: 'registered a new business', color: '--success' },
{ icon: '📅', text: 'created a reservation', color: '--primary' },
{ icon: '✅', text: 'checked in a customer', color: '--info' },
{ icon: '💳', text: 'upgraded subscription plan', color: '--purple' },
{ icon: '⚙️', text: 'updated business settings', color: '--warning' },
{ icon: '📊', text: 'generated monthly report', color: '--cyan' },
{ icon: '🎨', text: 'changed template design', color: '--pink' },
{ icon: '❌', text: 'cancelled a reservation', color: '--danger' }
];

dashboardState.activities = [];
for (let i = 0; i < 20; i++) {
const business = dashboardState.businesses[Math.floor(Math.random() * Math.min(10, dashboardState.businesses.length))];
const activity = activityTypes[Math.floor(Math.random() * activityTypes.length)];
const minutesAgo = Math.floor(Math.random() * 120);

dashboardState.activities.push({
icon: activity.icon,
text: `${business.name} ${activity.text}`,
time: minutesAgo < 60 ? `${minutesAgo} minutes ago` : `${Math.floor(minutesAgo / 60)} hours ago`,
location: business.owner,
color: activity.color
});
}
}

// ==================== RENDER FUNCTIONS ====================
function renderTopBusinesses() {
const container = document.getElementById('topBusinesses');
const topBusinesses = dashboardState.businesses.slice(0, 8);

container.innerHTML = topBusinesses.map(business => `
<div class="business-item" onclick="showBusinessDetailsModal(${business.id})">
<div class="business-info">
<div class="business-avatar">${business.name.charAt(0)}</div>
<div class="business-details">
<h4>${business.name}</h4>
<p>Owner: ${business.owner} • ${business.plan} Plan</p>
</div>
</div>
<div class="business-stats">
<div class="business-stat-item">
<div class="business-stat-value">${business.reservations}</div>
<div class="business-stat-label">Reservations</div>
</div>
<div class="business-stat-item">
<div class="business-stat-value">$${business.revenue}</div>
<div class="business-stat-label">Revenue</div>
</div>
<div class="business-stat-item">
<div class="business-stat-value">${business.rating}★</div>
<div class="business-stat-label">Rating</div>
</div>
</div>
</div>
`).join('');
}

function renderTemplateUsage() {
const container = document.getElementById('templateUsage');
const sortedTemplates = [...dashboardState.templates].sort((a, b) => b.count - a.count);

container.innerHTML = sortedTemplates.map(template => `
<div class="template-item" onclick="showTemplateDetailsModal('${template.name}')">
<div class="template-header">
<div class="template-name">
<span style="font-size: 18px;">📋</span>
${template.name}
</div>
<div class="template-count">${template.count}</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: ${template.percentage}%"></div>
</div>
<div class="usage-stats">
<span>${template.percentage}% of businesses</span>
<span>${template.count} active</span>
</div>
</div>
`).join('');
}

function renderActivityFeed() {
const container = document.getElementById('activityFeed');

container.innerHTML = dashboardState.activities.map(activity => `
<div class="activity-item">
<div class="activity-icon">${activity.icon}</div>
<div class="activity-content">
<div class="activity-text">${activity.text}</div>
<div class="activity-meta">
<span>⏱️ ${activity.time}</span>
<span>👤 ${activity.location}</span>
</div>
</div>
</div>
`).join('');

document.getElementById('activityCount').textContent = `${dashboardState.activities.length} events`;
}

function renderBusinessTable() {
const tbody = document.getElementById('businessTable');

tbody.innerHTML = dashboardState.businesses.map(business => `
<tr onclick="showBusinessDetailsModal(${business.id})" style="cursor: pointer;">
<td>
<div style="display: flex; align-items: center; gap: 10px;">
<div style="width: 36px; height: 36px; border-radius: 8px; background: linear-gradient(135deg, var(--primary), var(--purple)); display: flex; align-items: center; justify-content: center; font-weight: 700;">
${business.name.charAt(0)}
</div>
<strong>${business.name}</strong>
</div>
</td>
<td>${business.owner}</td>
<td><span class="badge badge-primary">${business.plan}</span></td>
<td><span class="status-badge status-${business.status}">${business.status}</span></td>
<td>${business.template}</td>
<td><strong>${business.reservations}</strong></td>
<td><strong style="color: var(--success);">$${business.revenue}</strong></td>
<td>${business.joinDate}</td>
<td>
<button style="padding: 6px 12px; background: var(--primary); border: none; border-radius: 6px; color: white; cursor: pointer; font-size: 11px; font-weight: 600;" onclick="event.stopPropagation(); showBusinessDetailsModal(${business.id})">
View Details
</button>
</td>
</tr>
`).join('');
}

// ==================== CHARTS ====================
function initializeCharts() {
createRevenueChart();
createSubscriptionChart();
}

function createRevenueChart() {
const canvas = document.getElementById('revenueChart');
const ctx = canvas.getContext('2d');

canvas.width = canvas.offsetWidth;
canvas.height = 300;

const data = [85, 92, 78, 105, 98, 112, 124.5];
const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
gradient.addColorStop(0, 'rgba(74, 158, 255, 0.3)');
gradient.addColorStop(1, 'rgba(74, 158, 255, 0)');

const padding = 40;
const chartWidth = canvas.width - padding * 2;
const chartHeight = canvas.height - padding * 2;
const maxValue = Math.max(...data) * 1.2;
const stepX = chartWidth / (data.length - 1);

const points = data.map((value, index) => ({
x: padding + index * stepX,
y: canvas.height - padding - (value / maxValue * chartHeight)
}));

ctx.strokeStyle = 'rgba(255, 255, 255, 0.05)';
ctx.lineWidth = 1;
for (let i = 0; i <= 4; i++) {
const y = padding + (chartHeight / 4) * i;
ctx.beginPath();
ctx.moveTo(padding, y);
ctx.lineTo(canvas.width - padding, y);
ctx.stroke();
}

ctx.fillStyle = gradient;
ctx.beginPath();
ctx.moveTo(points[0].x, canvas.height - padding);
points.forEach(point => ctx.lineTo(point.x, point.y));
ctx.lineTo(points[points.length - 1].x, canvas.height - padding);
ctx.closePath();
ctx.fill();

ctx.strokeStyle = '#4a9eff';
ctx.lineWidth = 3;
ctx.beginPath();
ctx.moveTo(points[0].x, points[0].y);
points.forEach(point => ctx.lineTo(point.x, point.y));
ctx.stroke();

points.forEach((point, index) => {
ctx.fillStyle = '#4a9eff';
ctx.beginPath();
ctx.arc(point.x, point.y, 5, 0, Math.PI * 2);
ctx.fill();
ctx.strokeStyle = '#1a2332';
ctx.lineWidth = 2;
ctx.stroke();

ctx.fillStyle = '#a8b5c7';
ctx.font = '11px Inter';
ctx.textAlign = 'center';
ctx.fillText(labels[index], point.x, canvas.height - 15);

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 11px Inter';
ctx.fillText(`$${data[index]}K`, point.x, point.y - 15);
});
}

function createSubscriptionChart() {
const canvas = document.getElementById('subscriptionChart');
const ctx = canvas.getContext('2d');

canvas.width = canvas.offsetWidth;
canvas.height = 300;

const data = [
{ label: 'Active', value: 198, color: '#10b981' },
{ label: 'Trial', value: 32, color: '#f59e0b' },
{ label: 'Inactive', value: 17, color: '#64748b' }
];

const total = data.reduce((sum, item) => sum + item.value, 0);
const centerX = canvas.width / 2;
const centerY = canvas.height / 2 - 20;
const radius = 90;

let currentAngle = -Math.PI / 2;

data.forEach((item, index) => {
const sliceAngle = (item.value / total) * Math.PI * 2;

ctx.fillStyle = item.color;
ctx.beginPath();
ctx.moveTo(centerX, centerY);
ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + sliceAngle);
ctx.closePath();
ctx.fill();

const labelAngle = currentAngle + sliceAngle / 2;
const labelX = centerX + Math.cos(labelAngle) * (radius + 30);
const labelY = centerY + Math.sin(labelAngle) * (radius + 30);

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 13px Inter';
ctx.textAlign = 'center';
ctx.fillText(item.label, labelX, labelY);

const percentage = ((item.value / total) * 100).toFixed(1);
ctx.font = '11px Inter';
ctx.fillStyle = '#a8b5c7';
ctx.fillText(`${item.value} (${percentage}%)`, labelX, labelY + 16);

currentAngle += sliceAngle;
});

ctx.fillStyle = '#1a2332';
ctx.beginPath();
ctx.arc(centerX, centerY, radius * 0.6, 0, Math.PI * 2);
ctx.fill();

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 24px Inter';
ctx.textAlign = 'center';
ctx.fillText(total, centerX, centerY - 5);
ctx.font = '12px Inter';
ctx.fillStyle = '#a8b5c7';
ctx.fillText('Total', centerX, centerY + 15);
}

// ==================== MODAL FUNCTIONS ====================
function createModal(title, icon, content) {
const modalContainer = document.getElementById('modalContainer');
modalContainer.innerHTML = `
<div class="modal-overlay" onclick="closeModal(event)">
<div class="modal-content" onclick="event.stopPropagation()">
<div class="modal-header">
<div class="modal-title">
${icon} ${title}
</div>
<div class="modal-close" onclick="closeModal()">×</div>
</div>
${content}
</div>
</div>
`;
}

function closeModal(event) {
if (event && event.target.className !== 'modal-overlay' && event.target.className !== 'modal-close') return;
const modalContainer = document.getElementById('modalContainer');
const overlay = modalContainer.querySelector('.modal-overlay');
if (overlay) {
overlay.style.opacity = '0';
setTimeout(() => {
modalContainer.innerHTML = '';
}, 300);
}
}

// ==================== DETAILED MODAL VIEWS ====================
function showBusinessesModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">247</div>
<div class="modal-stat-label">Total Businesses</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +28 this month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">198</div>
<div class="modal-stat-label">Active Subscriptions</div>
<div class="modal-stat-change" style="color: var(--success);">↗ 80.2% of total</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">32</div>
<div class="modal-stat-label">Trial Period</div>
<div class="modal-stat-change" style="color: var(--warning);">⚡ 13.0% of total</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">17</div>
<div class="modal-stat-label">Inactive</div>
<div class="modal-stat-change" style="color: var(--danger);">⚠️ 6.9% of total</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📈 Growth Trend (Last 12 Months)</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">New Signups</div>
<div class="comparison-value" style="color: var(--success);">+156</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Churned</div>
<div class="comparison-value" style="color: var(--danger);">-34</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Net Growth</div>
<div class="comparison-value" style="color: var(--primary);">+122</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Growth Rate</div>
<div class="comparison-value" style="color: var(--success);">+97.6%</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🏆 Business Type Distribution</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Fine Dining Restaurants</div>
<div class="detail-item-value">89 (36%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Casual Dining</div>
<div class="detail-item-value">72 (29%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Quick Service</div>
<div class="detail-item-value">48 (19%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Bars & Lounges</div>
<div class="detail-item-value">38 (15%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Key Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Fine dining segment shows highest engagement with 94% active rate</p>
<p style="margin-bottom: 8px;">• 28 new businesses added this month - highest growth in Q4</p>
<p style="margin-bottom: 8px;">• Northeast region leads with 87 businesses (35% market share)</p>
<p>• Trial-to-paid conversion rate at strong 78.5%</p>
</div>
</div>
`;
createModal('Total Businesses Subscribed', '🏢', content);
}

function showRevenueModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">$124.5K</div>
<div class="modal-stat-label">This Month MRR</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +$18.2K (17.1%)</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$106.3K</div>
<div class="modal-stat-label">Last Month MRR</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">Previous period</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$1.2M</div>
<div class="modal-stat-label">Year-to-Date</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +42.3% YoY</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$1.5M</div>
<div class="modal-stat-label">Annual Run Rate</div>
<div class="modal-stat-change" style="color: var(--primary);">📊 Projected</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💎 Revenue Breakdown by Plan</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Growth ($199/mo) - 42 businesses</div>
<div class="detail-item-value" style="color: var(--purple);">$68,418 (55%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter ($49/mo) - 116 businesses</div>
<div class="detail-item-value" style="color: var(--primary);">$38,893 (31%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter ($148/mo) - 116 businesses</div>
<div class="detail-item-value" style="color: var(--success);">$17,168 (14%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📈 Revenue Metrics</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">ARPU (Avg Revenue/User)</div>
<div class="comparison-value" style="color: var(--primary);">$504/mo</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Customer Lifetime Value</div>
<div class="comparison-value" style="color: var(--success);">$15,120</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Monthly Growth Rate</div>
<div class="comparison-value" style="color: var(--success);">+17.1%</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Revenue Churn</div>
<div class="comparison-value" style="color: var(--warning);">2.8%</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Revenue Insights</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Growth tier driving majority of growth with 12 new upgrades this month</p>
<p style="margin-bottom: 8px;">• Average contract value increased 11.2% due to feature adoption</p>
<p style="margin-bottom: 8px;">• Upsell rate at 23% - businesses upgrading within 3 months</p>
<p>• On track to reach $1.5M ARR by year end if current growth continues</p>
</div>
</div>
`;
createModal('Monthly Recurring Revenue Analysis', '💰', content);
}

function showReservationsModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">18,432</div>
<div class="modal-stat-label">This Month Total</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +3,652 (24.7%)</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">3,642</div>
<div class="modal-stat-label">Today's Reservations</div>
<div class="modal-stat-change" style="color: var(--primary);">⚡ Live count</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">74.6</div>
<div class="modal-stat-label">Avg Per Business</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +11.2 per day</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">91.6%</div>
<div class="modal-stat-label">Show-Up Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +5.3% improvement</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">⏰ Reservations by Time of Day</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">🌆 Dinner Peak (6PM-9PM)</div>
<div class="detail-item-value" style="color: var(--danger);">8,847 (48%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌅 Lunch Rush (11AM-2PM)</div>
<div class="detail-item-value" style="color: var(--warning);">6,234 (34%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌙 Late Night (9PM-Close)</div>
<div class="detail-item-value" style="color: var(--success);">2,189 (12%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">☀️ Off-Peak Hours</div>
<div class="detail-item-value" style="color: var(--cyan);">1,162 (6%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Party Size Distribution</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">2-Person Tables</div>
<div class="comparison-value" style="color: var(--primary);">7,836 (42.5%)</div>
</div>
<div class="comparison-item">
<div class="comparison-label">4-Person Tables</div>
<div class="comparison-value" style="color: var(--success);">6,289 (34.1%)</div>
</div>
<div class="comparison-item">
<div class="comparison-label">6+ Large Parties</div>
<div class="comparison-value" style="color: var(--purple);">2,947 (16.0%)</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Single Diners</div>
<div class="comparison-value" style="color: var(--cyan);">1,360 (7.4%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Reservation Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Saturday dinner slot most popular with 95% capacity fill rate</p>
<p style="margin-bottom: 8px;">• Average booking lead time: 4.2 days (up from 3.8 days)</p>
<p style="margin-bottom: 8px;">• Mobile bookings represent 67% of all reservations</p>
<p>• Repeat customer rate at impressive 42.3%</p>
</div>
</div>
`;
createModal('Reservation Analytics', '📅', content);
}

function showNoShowModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">8.4%</div>
<div class="modal-stat-label">Overall No-Show Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↓ -5.3% improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">1,548</div>
<div class="modal-stat-label">No-Shows This Month</div>
<div class="modal-stat-change" style="color: var(--danger);">⚠️ Lost revenue</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$78.4K</div>
<div class="modal-stat-label">Estimated Lost Revenue</div>
<div class="modal-stat-change" style="color: var(--danger);">💸 Opportunity cost</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">73%</div>
<div class="modal-stat-label">SMS Confirmation Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Reduces no-shows 42%</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 No-Show Rate by Time Slot</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">🌙 Late Night (9PM-Close)</div>
<div class="detail-item-value" style="color: var(--danger);">14.2%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌆 Dinner Peak (6PM-9PM)</div>
<div class="detail-item-value" style="color: var(--warning);">8.7%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌅 Lunch Rush (11AM-2PM)</div>
<div class="detail-item-value" style="color: var(--success);">5.3%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">☀️ Off-Peak Hours</div>
<div class="detail-item-value" style="color: var(--success);">3.8%</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🎯 Recommendations to Reduce No-Shows</div>
<div style="background: rgba(245, 158, 11, 0.1); border-left: 3px solid var(--warning); padding: 16px; border-radius: 8px; margin-bottom: 12px;">
<strong style="display: block; margin-bottom: 8px;">Immediate Actions:</strong>
<p style="margin-bottom: 6px;">• Enable SMS/Email confirmations 24hrs before reservation</p>
<p style="margin-bottom: 6px;">• Implement credit card requirement for large parties (6+)</p>
<p>• Offer waitlist auto-fill for last-minute cancellations</p>
</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<strong style="display: block; margin-bottom: 8px;">Long-term Strategies:</strong>
<p style="margin-bottom: 6px;">• Penalty system for repeat no-show customers</p>
<p style="margin-bottom: 6px;">• Deposit requirement during peak hours</p>
<p>• Loyalty program rewards for perfect attendance</p>
</div>
</div>
`;
createModal('No-Show Rate Analysis', '❌', content);
}

function showChurnModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">3.2%</div>
<div class="modal-stat-label">Monthly Churn Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↓ -2.1% improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">8</div>
<div class="modal-stat-label">Businesses Lost</div>
<div class="modal-stat-change" style="color: var(--danger);">⚠️ This month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$4,032</div>
<div class="modal-stat-label">MRR Lost</div>
<div class="modal-stat-change" style="color: var(--danger);">💸 Monthly impact</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">87.3%</div>
<div class="modal-stat-label">Retention Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ 12-month metric</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📉 Churn Reasons</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Went out of business</div>
<div class="detail-item-value" style="color: var(--text-tertiary);">3 (37.5%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Pricing concerns</div>
<div class="detail-item-value" style="color: var(--warning);">2 (25%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Switched to competitor</div>
<div class="detail-item-value" style="color: var(--danger);">2 (25%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Feature gaps</div>
<div class="detail-item-value" style="color: var(--warning);">1 (12.5%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Churn Prevention Strategy</div>
<div style="background: rgba(239, 68, 68, 0.1); border-left: 3px solid var(--danger); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Implement early warning system for at-risk accounts (low usage, payment issues)</p>
<p style="margin-bottom: 8px;">• Dedicated success manager for Growth tier customers</p>
<p style="margin-bottom: 8px;">• Quarterly business reviews with top 50 revenue-generating accounts</p>
<p>• Win-back campaign for churned customers with 3-month discount offer</p>
</div>
</div>
`;
createModal('Churn Rate Analysis', '📉', content);
}

function showRetentionModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">87.3%</div>
<div class="modal-stat-label">12-Month Retention</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +6.8% improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">92.1%</div>
<div class="modal-stat-label">6-Month Retention</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Strong early retention</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$15,120</div>
<div class="modal-stat-label">Customer LTV</div>
<div class="modal-stat-change" style="color: var(--primary);">📊 30-month avg tenure</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">78.5%</div>
<div class="modal-stat-label">Trial Conversion</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Best in class</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Retention by Plan Type</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Growth Plan</div>
<div class="detail-item-value" style="color: var(--success);">94.2%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter Plan</div>
<div class="detail-item-value" style="color: var(--primary);">88.7%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter Plan</div>
<div class="detail-item-value" style="color: var(--warning);">82.3%</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Retention Insights</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Growth customers showing exceptional 94.2% retention - premium support paying off</p>
<p style="margin-bottom: 8px;">• First 90 days critical: 92% of customers who survive this period stay 12+ months</p>
<p style="margin-bottom: 8px;">• Power users (>50 reservations/month) have 97% retention rate</p>
<p>• Onboarding improvements increased 6-month retention by 6.8%</p>
</div>
</div>
`;
createModal('Customer Retention Analysis', '🔁', content);
}

function showARPUModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">$504</div>
<div class="modal-stat-label">ARPU This Month</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +$51 (+11.2%)</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$453</div>
<div class="modal-stat-label">ARPU Last Month</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">Previous period</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$1,629</div>
<div class="modal-stat-label">Growth ARPU</div>
<div class="modal-stat-change" style="color: var(--purple);">💎 Premium tier</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">23%</div>
<div class="modal-stat-label">Upsell Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Within 3 months</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 ARPU by Plan</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Growth Plan</div>
<div class="detail-item-value" style="color: var(--purple);">$199/mo</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter Plan</div>
<div class="detail-item-value" style="color: var(--primary);">$437/mo</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter Plan</div>
<div class="detail-item-value" style="color: var(--success);">$148/mo</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 ARPU Growth Drivers</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• 12 businesses upgraded from Starter to Growth this month</p>
<p style="margin-bottom: 8px;">• Add-on features (SMS reminders, advanced analytics) contributing $47/mo avg</p>
<p style="margin-bottom: 8px;">• Price increase implemented in January driving +8.7% ARPU lift</p>
<p>• Growth tier adoption growing 3x faster than other plans</p>
</div>
</div>
`;
createModal('Average Revenue Per User', '💳', content);
}

function showTableTurnoverModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">3.2x</div>
<div class="modal-stat-label">Avg Daily Turnover</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +4.5% improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">4.8x</div>
<div class="modal-stat-label">Peak Hour Turnover</div>
<div class="modal-stat-change" style="color: var(--primary);">⚡ Dinner service</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">76 min</div>
<div class="modal-stat-label">Avg Dining Duration</div>
<div class="modal-stat-change" style="color: var(--warning);">⏱️ Per seating</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$147</div>
<div class="modal-stat-label">Avg Check Size</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +$12 per table</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🔄 Turnover by Service Period</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">🌆 Dinner Service (5PM-10PM)</div>
<div class="detail-item-value" style="color: var(--success);">4.8x turns</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌅 Lunch Service (11AM-3PM)</div>
<div class="detail-item-value" style="color: var(--primary);">3.4x turns</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌙 Late Night (10PM-Close)</div>
<div class="detail-item-value" style="color: var(--warning);">1.9x turns</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Optimization Opportunities</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Fine dining restaurants averaging 2.1x (luxury experience = longer stays)</p>
<p style="margin-bottom: 8px;">• Quick service establishments achieving 5.2x turnover rate</p>
<p style="margin-bottom: 8px;">• Implementing table time limits during peak hours could increase revenue 12-15%</p>
<p>• Smart seating algorithms improving turnover by 8.3% on average</p>
</div>
</div>
`;
createModal('Table Turnover Analysis', '🔄', content);
}

function showCACModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">$342</div>
<div class="modal-stat-label">Current CAC</div>
<div class="modal-stat-change" style="color: var(--success);">↓ -$33 (-8.7%)</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$375</div>
<div class="modal-stat-label">Previous CAC</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">Last month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$15,120</div>
<div class="modal-stat-label">Customer LTV</div>
<div class="modal-stat-change" style="color: var(--primary);">30-month tenure</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">44:1</div>
<div class="modal-stat-label">LTV:CAC Ratio</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Excellent ratio</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Acquisition Channels</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Organic Search & SEO</div>
<div class="detail-item-value" style="color: var(--success);">$178 CAC (42%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Referral Program</div>
<div class="detail-item-value" style="color: var(--success);">$89 CAC (28%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Paid Advertising</div>
<div class="detail-item-value" style="color: var(--warning);">$568 CAC (18%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Content Marketing</div>
<div class="detail-item-value" style="color: var(--primary);">$245 CAC (12%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 CAC Optimization Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Referral program driving lowest CAC at $89 - incentivize more referrals</p>
<p style="margin-bottom: 8px;">• Paid advertising CAC high at $568 - focus on organic channels</p>
<p style="margin-bottom: 8px;">• LTV:CAC ratio of 44:1 is exceptional (3:1 is considered healthy)</p>
<p>• Payback period: 2.3 months (industry standard: 12 months)</p>
</div>
</div>
`;
createModal('Customer Acquisition Cost', '💵', content);
}

function showBusinessDetailsModal(businessId) {
const business = dashboardState.businesses.find(b => b.id === businessId);
if (!business) return;

const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">${business.reservations}</div>
<div class="modal-stat-label">Monthly Reservations</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +12.3% vs last month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$${business.revenue}</div>
<div class="modal-stat-label">Monthly Revenue</div>
<div class="modal-stat-change" style="color: var(--success);">💰 Contribution</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${business.rating}★</div>
<div class="modal-stat-label">Customer Rating</div>
<div class="modal-stat-change" style="color: var(--primary);">⭐ ${Math.floor(Math.random() * 200 + 50)} reviews</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${business.activeUsers}</div>
<div class="modal-stat-label">Active Customers</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +8.2% growth</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📋 Business Information</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Owner</div>
<div class="detail-item-value">${business.owner}</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Subscription Plan</div>
<div class="detail-item-value">${business.plan}</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Template</div>
<div class="detail-item-value">${business.template}</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Status</div>
<div class="detail-item-value"><span class="status-badge status-${business.status}">${business.status}</span></div>
</div>
<div class="detail-item">
<div class="detail-item-label">Member Since</div>
<div class="detail-item-value">${business.joinDate}</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Performance Metrics</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">No-Show Rate</div>
<div class="comparison-value" style="color: ${parseFloat(business.noShowRate) > 10 ? 'var(--danger)' : 'var(--success)'};">${business.noShowRate}%</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Table Turnover</div>
<div class="comparison-value" style="color: var(--primary);">${business.avgTableTurnover}x</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Repeat Customer Rate</div>
<div class="comparison-value" style="color: var(--success);">${Math.floor(Math.random() * 30 + 35)}%</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Avg Check Size</div>
<div class="comparison-value" style="color: var(--primary);">$${Math.floor(Math.random() * 80 + 60)}</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Business Health</div>
<div style="background: ${business.status === 'active' ? 'rgba(16, 185, 129, 0.1)' : 'rgba(245, 158, 11, 0.1)'}; border-left: 3px solid ${business.status === 'active' ? 'var(--success)' : 'var(--warning)'}; padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• ${business.status === 'active' ? 'Business performing well with steady growth' : business.status === 'trial' ? 'In trial period - monitor for conversion' : 'Inactive account - reach out for reactivation'}</p>
<p style="margin-bottom: 8px;">• Feature adoption: ${Math.floor(Math.random() * 30 + 60)}% of available features in use</p>
<p>• Last login: ${Math.floor(Math.random() * 24 + 1)} hours ago</p>
</div>
</div>
`;
createModal(business.name, '🏢', content);
}

function showTemplateDetailsModal(templateName) {
const template = dashboardState.templates.find(t => t.name === templateName);
const businesses = dashboardState.businesses.filter(b => b.template === templateName);

const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">${template.count}</div>
<div class="modal-stat-label">Active Businesses</div>
<div class="modal-stat-change" style="color: var(--primary);">${template.percentage}% adoption</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${businesses.reduce((sum, b) => sum + b.reservations, 0).toLocaleString()}</div>
<div class="modal-stat-label">Total Reservations</div>
<div class="modal-stat-change" style="color: var(--success);">📅 This month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$${(businesses.reduce((sum, b) => sum + parseFloat(b.revenue), 0) / 1000).toFixed(1)}K</div>
<div class="modal-stat-label">Total Revenue</div>
<div class="modal-stat-change" style="color: var(--success);">💰 Generated</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${(businesses.reduce((sum, b) => sum + parseFloat(b.rating), 0) / businesses.length).toFixed(1)}★</div>
<div class="modal-stat-label">Avg Rating</div>
<div class="modal-stat-change" style="color: var(--primary);">⭐ Customer satisfaction</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🏆 Top Performing Businesses Using This Template</div>
<div class="detail-list">
${businesses.slice(0, 5).map(b => `
<div class="detail-item">
<div class="detail-item-label">${b.name}</div>
<div class="detail-item-value">${b.reservations} reservations</div>
</div>
`).join('')}
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Template Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• ${template.count} businesses actively using this template</p>
<p style="margin-bottom: 8px;">• Average ${Math.floor(businesses.reduce((sum, b) => sum + b.reservations, 0) / businesses.length)} reservations per business</p>
<p>• Template accounts for ${template.percentage}% of all platform activity</p>
</div>
</div>
`;
createModal(templateName + ' Template', '📋', content);
}

function showSystemHealthModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">124ms</div>
<div class="modal-stat-label">API Response Time</div>
<div class="modal-stat-change" style="color: var(--success);">✓ Excellent</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">68%</div>
<div class="modal-stat-label">Database Load</div>
<div class="modal-stat-change" style="color: var(--warning);">⚠️ Moderate</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">99.8%</div>
<div class="modal-stat-label">Server Uptime</div>
<div class="modal-stat-change" style="color: var(--success);">✓ 28d 4h 32m</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">2,847</div>
<div class="modal-stat-label">Active Sessions</div>
<div class="modal-stat-change" style="color: var(--primary);">📊 Real-time</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🌐 Infrastructure Status</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Web Servers</div>
<div class="detail-item-value" style="color: var(--success);">✓ All operational (8/8)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Database Cluster</div>
<div class="detail-item-value" style="color: var(--success);">✓ Healthy (3 nodes)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">CDN Performance</div>
<div class="detail-item-value" style="color: var(--success);">✓ 42ms avg latency</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Storage Capacity</div>
<div class="detail-item-value" style="color: var(--warning);">⚠️ 72% used</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Backup Status</div>
<div class="detail-item-value" style="color: var(--success);">✓ Last backup: 2h ago</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Performance Trends (7 Days)</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">Avg Response Time</div>
<div class="comparison-value" style="color: var(--success);">134ms</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Peak Concurrent Users</div>
<div class="comparison-value" style="color: var(--primary);">4,892</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Error Rate</div>
<div class="comparison-value" style="color: var(--success);">0.08%</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Data Transferred</div>
<div class="comparison-value" style="color: var(--primary);">2.4 TB</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">⚠️ Alerts & Recommendations</div>
<div style="background: rgba(245, 158, 11, 0.1); border-left: 3px solid var(--warning); padding: 16px; border-radius: 8px; margin-bottom: 12px;">
<p style="margin-bottom: 8px;"><strong>Medium Priority:</strong></p>
<p style="margin-bottom: 6px;">• Database load at 68% - consider scaling during peak hours</p>
<p>• Storage at 72% - plan capacity expansion within 30 days</p>
</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;"><strong>All Systems Nominal:</strong></p>
<p style="margin-bottom: 6px;">• API response times well below target threshold</p>
<p style="margin-bottom: 6px;">• Uptime exceeding 99.5% SLA commitment</p>
<p>• Error rates within acceptable ranges</p>
</div>
</div>
`;
createModal('System Health & Performance', '💊', content);
}

function showRevenueChartModal() {
const content = `
<div class="modal-section">
<div class="modal-section-title">📈 Detailed Revenue Analysis</div>
<div class="modal-chart-container">
<canvas id="detailedRevenueChart" style="width: 100%; height: 400px;"></canvas>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Monthly Comparison</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">November 2024</div>
<div class="detail-item-value" style="color: var(--primary);">$124,500</div>
</div>
<div class="detail-item">
<div class="detail-item-label">October 2024</div>
<div class="detail-item-value" style="color: var(--text-secondary);">$106,300</div>
</div>
<div class="detail-item">
<div class="detail-item-label">September 2024</div>
<div class="detail-item-value" style="color: var(--text-secondary);">$98,700</div>
</div>
<div class="detail-item">
<div class="detail-item-label">August 2024</div>
<div class="detail-item-value" style="color: var(--text-secondary);">$95,200</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Revenue Insights</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Consistent month-over-month growth averaging 14.2%</p>
<p style="margin-bottom: 8px;">• Q4 on track for record $368K quarterly revenue</p>
<p style="margin-bottom: 8px;">• Growth tier upgrades driving 55% of revenue growth</p>
<p>• Projected to reach $1.5M ARR by end of fiscal year</p>
</div>
</div>
`;
createModal('Revenue & Growth Analytics', '💰', content);

setTimeout(() => {
const canvas = document.getElementById('detailedRevenueChart');
if (canvas) {
const ctx = canvas.getContext('2d');
canvas.width = canvas.offsetWidth;
canvas.height = 400;

const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
const data = [68, 72, 78, 82, 87, 91, 95, 95.2, 98.7, 106.3, 124.5];

const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
gradient.addColorStop(0, 'rgba(74, 158, 255, 0.4)');
gradient.addColorStop(1, 'rgba(74, 158, 255, 0)');

const padding = 60;
const chartWidth = canvas.width - padding * 2;
const chartHeight = canvas.height - padding * 2;
const maxValue = Math.max(...data) * 1.2;
const stepX = chartWidth / (data.length - 1);

const points = data.map((value, index) => ({
x: padding + index * stepX,
y: canvas.height - padding - (value / maxValue * chartHeight)
}));

// Draw grid
ctx.strokeStyle = 'rgba(255, 255, 255, 0.05)';
ctx.lineWidth = 1;
for (let i = 0; i <= 5; i++) {
const y = padding + (chartHeight / 5) * i;
ctx.beginPath();
ctx.moveTo(padding, y);
ctx.lineTo(canvas.width - padding, y);
ctx.stroke();
}

// Draw area
ctx.fillStyle = gradient;
ctx.beginPath();
ctx.moveTo(points[0].x, canvas.height - padding);
points.forEach(point => ctx.lineTo(point.x, point.y));
ctx.lineTo(points[points.length - 1].x, canvas.height - padding);
ctx.closePath();
ctx.fill();

// Draw line
ctx.strokeStyle = '#4a9eff';
ctx.lineWidth = 4;
ctx.beginPath();
ctx.moveTo(points[0].x, points[0].y);
points.forEach(point => ctx.lineTo(point.x, point.y));
ctx.stroke();

// Draw points and labels
points.forEach((point, index) => {
ctx.fillStyle = '#4a9eff';
ctx.beginPath();
ctx.arc(point.x, point.y, 6, 0, Math.PI * 2);
ctx.fill();
ctx.strokeStyle = '#1a2332';
ctx.lineWidth = 3;
ctx.stroke();

ctx.fillStyle = '#a8b5c7';
ctx.font = '12px Inter';
ctx.textAlign = 'center';
ctx.fillText(months[index], point.x, canvas.height - 25);

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 13px Inter';
ctx.fillText(`$${data[index]}K`, point.x, point.y - 15);
});
}
}, 100);
}

function showSubscriptionChartModal() {
const content = `
<div class="modal-section">
<div class="modal-section-title">🎯 Subscription Distribution Details</div>
<div class="modal-chart-container">
<canvas id="detailedSubscriptionChart" style="width: 100%; height: 400px;"></canvas>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Subscription Breakdown</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Active Subscriptions</div>
<div class="detail-item-value" style="color: var(--success);">198 (80.2%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Trial Subscriptions</div>
<div class="detail-item-value" style="color: var(--warning);">32 (13.0%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Inactive Subscriptions</div>
<div class="detail-item-value" style="color: var(--text-tertiary);">17 (6.9%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Subscription Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• 80.2% active rate indicates strong product-market fit</p>
<p style="margin-bottom: 8px;">• 32 businesses in trial - potential for $16K+ additional MRR</p>
<p style="margin-bottom: 8px;">• Inactive accounts represent reactivation opportunity</p>
<p>• Trial-to-paid conversion running at healthy 78.5%</p>
</div>
</div>
`;
createModal('Business Distribution Analysis', '🎯', content);

setTimeout(() => {
const canvas = document.getElementById('detailedSubscriptionChart');
if (canvas) {
const ctx = canvas.getContext('2d');
canvas.width = canvas.offsetWidth;
canvas.height = 400;

const data = [
{ label: 'Active', value: 198, color: '#10b981' },
{ label: 'Trial', value: 32, color: '#f59e0b' },
{ label: 'Inactive', value: 17, color: '#64748b' }
];

const total = data.reduce((sum, item) => sum + item.value, 0);
const centerX = canvas.width / 2;
const centerY = canvas.height / 2;
const radius = 120;

let currentAngle = -Math.PI / 2;

data.forEach((item) => {
const sliceAngle = (item.value / total) * Math.PI * 2;

ctx.fillStyle = item.color;
ctx.beginPath();
ctx.moveTo(centerX, centerY);
ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + sliceAngle);
ctx.closePath();
ctx.fill();

const labelAngle = currentAngle + sliceAngle / 2;
const labelX = centerX + Math.cos(labelAngle) * (radius + 40);
const labelY = centerY + Math.sin(labelAngle) * (radius + 40);

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 16px Inter';
ctx.textAlign = 'center';
ctx.fillText(item.label, labelX, labelY);

const percentage = ((item.value / total) * 100).toFixed(1);
ctx.font = '14px Inter';
ctx.fillStyle = '#a8b5c7';
ctx.fillText(`${item.value} (${percentage}%)`, labelX, labelY + 20);

currentAngle += sliceAngle;
});

ctx.fillStyle = '#1a2332';
ctx.beginPath();
ctx.arc(centerX, centerY, radius * 0.55, 0, Math.PI * 2);
ctx.fill();

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 32px Inter';
ctx.textAlign = 'center';
ctx.fillText(total, centerX, centerY - 10);
ctx.font = '14px Inter';
ctx.fillStyle = '#a8b5c7';
ctx.fillText('Total Businesses', centerX, centerY + 15);
}
}, 100);
}

function showUptimeModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">99.8%</div>
<div class="modal-stat-label">30-Day Uptime</div>
<div class="modal-stat-change" style="color: var(--success);">✓ Excellent</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">99.6%</div>
<div class="modal-stat-label">90-Day Uptime</div>
<div class="modal-stat-change" style="color: var(--success);">✓ Above SLA</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">28d 4h</div>
<div class="modal-stat-label">Current Uptime</div>
<div class="modal-stat-change" style="color: var(--primary);">⏱️ Consecutive</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">14 days</div>
<div class="modal-stat-label">Last Incident</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">🔧 Minor outage</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Incident History (Last 90 Days)</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Major Outages</div>
<div class="detail-item-value" style="color: var(--success);">0</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Minor Incidents</div>
<div class="detail-item-value" style="color: var(--warning);">2</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Total Downtime</div>
<div class="detail-item-value" style="color: var(--text-tertiary);">4h 32m</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Planned Maintenance</div>
<div class="detail-item-value" style="color: var(--primary);">3h 15m</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Uptime Analysis</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Platform exceeding 99.5% uptime SLA commitment</p>
<p style="margin-bottom: 8px;">• Last incident: Database connection timeout (resolved in 18 minutes)</p>
<p style="margin-bottom: 8px;">• Redundancy systems prevented customer-facing impact in 2 incidents</p>
<p>• Next planned maintenance: December 15th, 2AM-4AM EST</p>
</div>
</div>
`;
createModal('Platform Uptime & Reliability', '⚡', content);
}

function showUsersModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">43,892</div>
<div class="modal-stat-label">Active End Users</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +5,812 this month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">8,234</div>
<div class="modal-stat-label">New Users (30d)</div>
<div class="modal-stat-change" style="color: var(--primary);">👋 First-time visitors</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">42.3%</div>
<div class="modal-stat-label">Repeat Customer Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Strong loyalty</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">67%</div>
<div class="modal-stat-label">Mobile Users</div>
<div class="modal-stat-change" style="color: var(--primary);">📱 Platform usage</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📱 User Platform Distribution</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Mobile (iOS + Android)</div>
<div class="detail-item-value" style="color: var(--primary);">29,408 (67%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Desktop/Laptop</div>
<div class="detail-item-value" style="color: var(--success);">12,684 (29%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Tablet</div>
<div class="detail-item-value" style="color: var(--warning);">1,800 (4%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 User Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• 67% mobile usage confirms mobile-first strategy is correct</p>
<p style="margin-bottom: 8px;">• 42.3% repeat rate indicates strong customer satisfaction</p>
<p style="margin-bottom: 8px;">• Average user books 2.4 reservations per month</p>
<p>• Peak booking times: Weekdays 11AM-2PM and weekends 5PM-8PM</p>
</div>
</div>
`;
createModal('Active End Users Analysis', '👥', content);
}

function showRatingModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">4.7★</div>
<div class="modal-stat-label">Average Rating</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +0.2 improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">8,234</div>
<div class="modal-stat-label">Total Reviews</div>
<div class="modal-stat-change" style="color: var(--primary);">📝 Submitted</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">72%</div>
<div class="modal-stat-label">5-Star Reviews</div>
<div class="modal-stat-change" style="color: var(--success);">⭐ Excellent</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">38%</div>
<div class="modal-stat-label">Review Rate</div>
<div class="modal-stat-change" style="color: var(--primary);">📊 Customers who review</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">⭐ Rating Distribution</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">⭐⭐⭐⭐⭐ 5 Stars</div>
<div class="detail-item-value" style="color: var(--success);">5,892 (71.6%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">⭐⭐⭐⭐ 4 Stars</div>
<div class="detail-item-value" style="color: var(--primary);">1,647 (20.0%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">⭐⭐⭐ 3 Stars</div>
<div class="detail-item-value" style="color: var(--warning);">412 (5.0%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">⭐⭐ 2 Stars & Below</div>
<div class="detail-item-value" style="color: var(--danger);">283 (3.4%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Rating Insights</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• 4.7-star average places platform in top 10% of restaurant tech</p>
<p style="margin-bottom: 8px;">• 91.6% of reviews are 4-5 stars indicating high satisfaction</p>
<p style="margin-bottom: 8px;">• Response rate to negative reviews: 94% (excellent recovery)</p>
<p>• Common praise: ease of use, quick booking, reliable system</p>
</div>
</div>
`;
createModal('Customer Ratings & Reviews', '⭐', content);
}

function showPlanDetails(planName) {
const planData = {
enterprise: {
name: 'Growth Plan',
price: '$199/mo',
count: 42,
mrr: '$68,418',
features: 'Unlimited reservations, Priority support, Advanced analytics, Custom branding, API access',
avgReservations: 438
},
professional: {
name: 'Starter Plan',
price: '$437/mo',
count: 89,
mrr: '$38,893',
features: 'Up to 500 reservations/mo, Email support, Standard analytics, Basic customization',
avgReservations: 247
},
starter: {
name: 'Starter Plan',
price: '$148/mo',
count: 116,
mrr: '$17,168',
features: 'Up to 150 reservations/mo, Community support, Basic analytics',
avgReservations: 74
}
};

const plan = planData[planName];
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">${plan.count}</div>
<div class="modal-stat-label">Active Subscriptions</div>
<div class="modal-stat-change" style="color: var(--primary);">🏢 Businesses</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${plan.mrr}</div>
<div class="modal-stat-label">Monthly Revenue</div>
<div class="modal-stat-change" style="color: var(--success);">💰 From this plan</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${plan.price}</div>
<div class="modal-stat-label">Plan Price</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">Per month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${plan.avgReservations}</div>
<div class="modal-stat-label">Avg Reservations</div>
<div class="modal-stat-change" style="color: var(--primary);">📅 Per business/month</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">✨ Plan Features</div>
<div style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--border-color); padding: 20px; border-radius: 10px;">
<p style="line-height: 1.8; color: var(--text-primary);">${plan.features}</p>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Plan Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• ${plan.count} businesses actively using ${plan.name}</p>
<p style="margin-bottom: 8px;">• Average ${plan.avgReservations} reservations per business per month</p>
<p style="margin-bottom: 8px;">• Contributing ${((parseFloat(plan.mrr.replace(/[$,K]/g, '')) / 124.5) * 100).toFixed(1)}% to total MRR</p>
<p>• ${planName === 'enterprise' ? 'Highest retention rate at 94.2%' : planName === 'professional' ? 'Popular mid-tier option with 36% of customer base' : 'Great entry point with 78.5% trial conversion'}</p>
</div>
</div>
`;
createModal(plan.name, '💎', content);
}

// ==================== INTERACTION FUNCTIONS ====================
function refreshDashboard() {
showToast('Refreshing dashboard data...', 'info');
setTimeout(() => {
generateActivityFeed();
renderActivityFeed();
updateMetrics();
showToast('Dashboard refreshed successfully!', 'success');
}, 1000);
}

function updateMetrics() {
const totalBusinesses = document.getElementById('totalBusinesses');
const totalReservations = document.getElementById('totalReservations');

const newBusinessCount = parseInt(totalBusinesses.textContent) + Math.floor(Math.random() * 3);
const newReservationCount = parseInt(totalReservations.textContent.replace(',', '')) + Math.floor(Math.random() * 50);

totalBusinesses.textContent = newBusinessCount;
totalReservations.textContent = newReservationCount.toLocaleString();
}

function exportReport() {
showToast('Generating comprehensive report...', 'info');
setTimeout(() => {
showToast('Report exported successfully! Check your downloads.', 'success');
}, 1500);
}

function viewDetailedAnalytics() {
	const content = `
	<div class="modal-tabs">
		<button class="modal-tab active" onclick="switchAnalyticsTab('revenue')">💰 Revenue</button>
		<button class="modal-tab" onclick="switchAnalyticsTab('users')">👥 Users</button>
		<button class="modal-tab" onclick="switchAnalyticsTab('conversion')">📊 Conversion</button>
		<button class="modal-tab" onclick="switchAnalyticsTab('trends')">📈 Trends</button>
	</div>
	
	<div id="analyticsContent">
		<!-- Content will be loaded dynamically -->
	</div>
	`;
	
	createModal('Detailed Analytics Dashboard', '📈', content);
	switchAnalyticsTab('revenue');
}

function switchAnalyticsTab(tab) {
	// Update active tab
	document.querySelectorAll('.modal-tab').forEach(btn => btn.classList.remove('active'));
	event?.target?.classList.add('active');
	
	const contentArea = document.getElementById('analyticsContent');
	
	switch(tab) {
		case 'revenue':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">$124,479</div>
						<div class="modal-stat-label">Total MRR</div>
						<div class="modal-stat-change" style="color: var(--success);">↑ 18.2% vs last month</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$1,493,748</div>
						<div class="modal-stat-label">Annual Revenue</div>
						<div class="modal-stat-change" style="color: var(--success);">↑ $247K projected growth</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$504</div>
						<div class="modal-stat-label">ARPU</div>
						<div class="modal-stat-change" style="color: var(--primary);">Avg Revenue per User</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">2.4x</div>
						<div class="modal-stat-label">LTV/CAC Ratio</div>
						<div class="modal-stat-change" style="color: var(--success);">Excellent health</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💎 Revenue by Plan Type</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">Growth Plan ($199/mo)</div>
							<div class="detail-item-value" style="color: var(--success);">$68,418 <span style="opacity: 0.6; font-size: 12px;">(54.9%)</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">Starter Plan ($437/mo)</div>
							<div class="detail-item-value" style="color: var(--primary);">$38,893 <span style="opacity: 0.6; font-size: 12px;">(31.2%)</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">Starter Plan ($148/mo)</div>
							<div class="detail-item-value" style="color: var(--info);">$17,168 <span style="opacity: 0.6; font-size: 12px;">(13.8%)</span></div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📊 Revenue Growth Timeline</div>
					<div style="background: rgba(255, 255, 255, 0.02); padding: 20px; border-radius: 10px;">
						<div style="display: grid; gap: 12px;">
							<div style="display: flex; justify-content: space-between; padding: 12px; background: rgba(74, 158, 255, 0.1); border-radius: 8px;">
								<span>Q4 2024 (Oct-Dec)</span>
								<strong style="color: var(--success);">$346,219 <span style="opacity: 0.7;">↑ 12%</span></strong>
							</div>
							<div style="display: flex; justify-content: space-between; padding: 12px; background: rgba(74, 158, 255, 0.08); border-radius: 8px;">
								<span>Q3 2024 (Jul-Sep)</span>
								<strong style="color: var(--success);">$309,485 <span style="opacity: 0.7;">↑ 15%</span></strong>
							</div>
							<div style="display: flex; justify-content: space-between; padding: 12px; background: rgba(74, 158, 255, 0.06); border-radius: 8px;">
								<span>Q2 2024 (Apr-Jun)</span>
								<strong>$268,943 <span style="opacity: 0.7;">↑ 18%</span></strong>
							</div>
							<div style="display: flex; justify-content: space-between; padding: 12px; background: rgba(74, 158, 255, 0.04); border-radius: 8px;">
								<span>Q1 2024 (Jan-Mar)</span>
								<strong>$228,074</strong>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Revenue Insights</div>
					<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Growth plans drive 55% of revenue with only 17% of customer base</p>
						<p style="margin-bottom: 8px;">• Upgrade rate from Starter to Growth: 23.4% (industry avg: 18%)</p>
						<p style="margin-bottom: 8px;">• Average time to upgrade: 4.3 months</p>
						<p>• Cross-sell opportunities: Additional templates purchased by 34% of Growth users</p>
					</div>
				</div>
			`;
			break;
			
		case 'users':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">247</div>
						<div class="modal-stat-label">Total Businesses</div>
						<div class="modal-stat-change" style="color: var(--success);">↑ 23 this month</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">89.2%</div>
						<div class="modal-stat-label">Active Rate</div>
						<div class="modal-stat-change" style="color: var(--success);">220 businesses active</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">4.8</div>
						<div class="modal-stat-label">Avg Satisfaction</div>
						<div class="modal-stat-change" style="color: var(--warning);">Out of 5 stars</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">94.7%</div>
						<div class="modal-stat-label">Retention Rate</div>
						<div class="modal-stat-change" style="color: var(--success);">12-month average</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">👥 User Engagement Metrics</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">Daily Active Users (DAU)</div>
							<div class="detail-item-value" style="color: var(--success);">187 <span style="opacity: 0.6; font-size: 12px;">75.7% of user base</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">Weekly Active Users (WAU)</div>
							<div class="detail-item-value" style="color: var(--primary);">231 <span style="opacity: 0.6; font-size: 12px;">93.5% of user base</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">Average Session Duration</div>
							<div class="detail-item-value" style="color: var(--info);">18m 42s <span style="opacity: 0.6; font-size: 12px;">↑ 12% vs last month</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">Sessions per User per Day</div>
							<div class="detail-item-value" style="color: var(--cyan);">3.7 <span style="opacity: 0.6; font-size: 12px;">Highly engaged</span></div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🎯 Feature Adoption</div>
					<div style="display: grid; gap: 10px;">
						<div style="padding: 12px; background: rgba(74, 158, 255, 0.1); border-radius: 8px;">
							<div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
								<span>📅 Reservation Management</span>
								<strong style="color: var(--success);">98.4%</strong>
							</div>
							<div style="height: 6px; background: rgba(255,255,255,0.1); border-radius: 3px; overflow: hidden;">
								<div style="width: 98.4%; height: 100%; background: var(--success);"></div>
							</div>
						</div>
						<div style="padding: 12px; background: rgba(74, 158, 255, 0.08); border-radius: 8px;">
							<div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
								<span>📊 Analytics Dashboard</span>
								<strong style="color: var(--primary);">76.2%</strong>
							</div>
							<div style="height: 6px; background: rgba(255,255,255,0.1); border-radius: 3px; overflow: hidden;">
								<div style="width: 76.2%; height: 100%; background: var(--primary);"></div>
							</div>
						</div>
						<div style="padding: 12px; background: rgba(74, 158, 255, 0.06); border-radius: 8px;">
							<div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
								<span>📧 Email Notifications</span>
								<strong style="color: var(--info);">84.1%</strong>
							</div>
							<div style="height: 6px; background: rgba(255,255,255,0.1); border-radius: 3px; overflow: hidden;">
								<div style="width: 84.1%; height: 100%; background: var(--info);"></div>
							</div>
						</div>
						<div style="padding: 12px; background: rgba(74, 158, 255, 0.04); border-radius: 8px;">
							<div style="display: flex; justify-content: space-between; margin-bottom: 6px;">
								<span>🎨 Custom Branding</span>
								<strong style="color: var(--purple);">42.3%</strong>
							</div>
							<div style="height: 6px; background: rgba(255,255,255,0.1); border-radius: 3px; overflow: hidden;">
								<div style="width: 42.3%; height: 100%; background: var(--purple);"></div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 User Insights</div>
					<div style="background: rgba(99, 102, 241, 0.1); border-left: 3px solid var(--info); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Power users (10+ logins/week): 124 businesses (50.2%)</p>
						<p style="margin-bottom: 8px;">• Mobile app usage: 67% of total sessions</p>
						<p style="margin-bottom: 8px;">• Peak usage hours: 10am-12pm and 5pm-7pm</p>
						<p>• Average support ticket response time: 2.3 hours</p>
					</div>
				</div>
			`;
			break;
			
		case 'conversion':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">78.5%</div>
						<div class="modal-stat-label">Trial Conversion</div>
						<div class="modal-stat-change" style="color: var(--success);">↑ 5.2% vs industry avg</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">14 days</div>
						<div class="modal-stat-label">Avg Trial Length</div>
						<div class="modal-stat-change" style="color: var(--primary);">Before conversion</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$247</div>
						<div class="modal-stat-label">CAC</div>
						<div class="modal-stat-change" style="color: var(--info);">Customer Acquisition Cost</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$1,210</div>
						<div class="modal-stat-label">LTV</div>
						<div class="modal-stat-change" style="color: var(--success);">Lifetime Value</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🎯 Conversion Funnel</div>
					<div style="display: grid; gap: 8px;">
						<div style="position: relative; padding: 16px; background: linear-gradient(90deg, rgba(74, 158, 255, 0.3), rgba(74, 158, 255, 0.1)); border-radius: 8px;">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span style="font-weight: 600;">1️⃣ Website Visitors</span>
								<strong style="font-size: 18px;">47,842</strong>
							</div>
						</div>
						<div style="position: relative; padding: 16px; background: linear-gradient(90deg, rgba(74, 158, 255, 0.25), rgba(74, 158, 255, 0.08)); border-radius: 8px; margin-left: 20px;">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span style="font-weight: 600;">2️⃣ Sign-ups Started</span>
								<strong style="font-size: 18px;">12,438 <span style="opacity: 0.6; font-size: 14px;">(26.0%)</span></strong>
							</div>
						</div>
						<div style="position: relative; padding: 16px; background: linear-gradient(90deg, rgba(74, 158, 255, 0.2), rgba(74, 158, 255, 0.06)); border-radius: 8px; margin-left: 40px;">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span style="font-weight: 600;">3️⃣ Trials Activated</span>
								<strong style="font-size: 18px;">8,247 <span style="opacity: 0.6; font-size: 14px;">(66.3%)</span></strong>
							</div>
						</div>
						<div style="position: relative; padding: 16px; background: linear-gradient(90deg, rgba(16, 185, 129, 0.2), rgba(16, 185, 129, 0.06)); border-radius: 8px; margin-left: 60px;">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span style="font-weight: 600;">4️⃣ Paid Conversions</span>
								<strong style="font-size: 18px; color: var(--success);">6,474 <span style="opacity: 0.6; font-size: 14px;">(78.5%)</span></strong>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📈 Conversion by Traffic Source</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">🔍 Organic Search</div>
							<div class="detail-item-value">
								<span style="color: var(--success);">82.3%</span>
								<span style="opacity: 0.6; font-size: 12px; margin-left: 8px;">18,247 conversions</span>
							</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">👥 Referrals</div>
							<div class="detail-item-value">
								<span style="color: var(--primary);">76.8%</span>
								<span style="opacity: 0.6; font-size: 12px; margin-left: 8px;">4,892 conversions</span>
							</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">📱 Social Media</div>
							<div class="detail-item-value">
								<span style="color: var(--info);">68.4%</span>
								<span style="opacity: 0.6; font-size: 12px; margin-left: 8px;">2,147 conversions</span>
							</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">📧 Email Marketing</div>
							<div class="detail-item-value">
								<span style="color: var(--warning);">91.2%</span>
								<span style="opacity: 0.6; font-size: 12px; margin-left: 8px;">1,328 conversions</span>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Conversion Insights</div>
					<div style="background: rgba(245, 158, 11, 0.1); border-left: 3px solid var(--warning); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Top converting feature during trial: Reservation management (mentioned by 94%)</p>
						<p style="margin-bottom: 8px;">• Users who add 10+ reservations during trial convert at 96%</p>
						<p style="margin-bottom: 8px;">• Support engagement increases conversion rate by 34%</p>
						<p>• Optimal trial length: 14 days (highest conversion at day 11-14)</p>
					</div>
				</div>
			`;
			break;
			
		case 'trends':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">+18.2%</div>
						<div class="modal-stat-label">MRR Growth</div>
						<div class="modal-stat-change" style="color: var(--success);">Month over month</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">+23</div>
						<div class="modal-stat-label">Net New Customers</div>
						<div class="modal-stat-change" style="color: var(--success);">This month</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">-2.8%</div>
						<div class="modal-stat-label">Churn Rate</div>
						<div class="modal-stat-change" style="color: var(--success);">Below industry avg (5%)</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">137%</div>
						<div class="modal-stat-label">NDR</div>
						<div class="modal-stat-change" style="color: var(--success);">Net Dollar Retention</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📊 Growth Trajectory (Last 12 Months)</div>
					<div style="background: rgba(255, 255, 255, 0.02); padding: 20px; border-radius: 10px;">
						<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;">
							<div style="text-align: center; padding: 16px; background: rgba(74, 158, 255, 0.1); border-radius: 8px;">
								<div style="font-size: 28px; font-weight: 700; color: var(--success);">+124%</div>
								<div style="font-size: 12px; opacity: 0.8; margin-top: 4px;">YoY Revenue</div>
							</div>
							<div style="text-align: center; padding: 16px; background: rgba(16, 185, 129, 0.1); border-radius: 8px;">
								<div style="font-size: 28px; font-weight: 700; color: var(--success);">+89</div>
								<div style="font-size: 12px; opacity: 0.8; margin-top: 4px;">New Businesses</div>
							</div>
							<div style="text-align: center; padding: 16px; background: rgba(99, 102, 241, 0.1); border-radius: 8px;">
								<div style="font-size: 28px; font-weight: 700; color: var(--info);">247K</div>
								<div style="font-size: 12px; opacity: 0.8; margin-top: 4px;">Total Reservations</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🎯 Key Performance Trends</div>
					<div style="display: grid; gap: 10px;">
						<div style="padding: 14px; background: rgba(16, 185, 129, 0.1); border-radius: 8px; border-left: 3px solid var(--success);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>📈 Average Deal Size</span>
								<strong style="color: var(--success);">↑ $142 (32% increase)</strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(74, 158, 255, 0.1); border-radius: 8px; border-left: 3px solid var(--primary);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>⏱️ Sales Cycle Length</span>
								<strong style="color: var(--primary);">↓ 8.2 days (24% faster)</strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(99, 102, 241, 0.1); border-radius: 8px; border-left: 3px solid var(--info);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>🎯 Lead Conversion Rate</span>
								<strong style="color: var(--info);">↑ 12.4% (from 66.1% to 78.5%)</strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(6, 182, 212, 0.1); border-radius: 8px; border-left: 3px solid var(--cyan);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>👥 Customer Satisfaction</span>
								<strong style="color: var(--cyan);">↑ 0.3 points (now 4.8/5.0)</strong>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🔮 Forecast & Projections</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">💰 Projected Annual Revenue (2025)</div>
							<div class="detail-item-value" style="color: var(--success);">$1.74M <span style="opacity: 0.6; font-size: 12px;">+16.5% YoY</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">👥 Projected Customer Count (EOY)</div>
							<div class="detail-item-value" style="color: var(--primary);">312 <span style="opacity: 0.6; font-size: 12px;">+26% growth</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">📊 Expected MRR (Dec 2025)</div>
							<div class="detail-item-value" style="color: var(--info);">$145K <span style="opacity: 0.6; font-size: 12px;">+16.5% from current</span></div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Trend Insights</div>
					<div style="background: rgba(168, 85, 247, 0.1); border-left: 3px solid var(--purple); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Growth segment showing strongest growth at 42% MoM</p>
						<p style="margin-bottom: 8px;">• Restaurant industry adoption up 67% this quarter</p>
						<p style="margin-bottom: 8px;">• Mobile app usage growing 3x faster than web platform</p>
						<p>• Peak growth months: March, June, September (post-quarter planning cycles)</p>
					</div>
				</div>
			`;
			break;
	}
}

function manageSubscriptions() {
	const content = `
	<div class="modal-tabs">
		<button class="modal-tab active" onclick="switchSubscriptionTab('overview')">📊 Overview</button>
		<button class="modal-tab" onclick="switchSubscriptionTab('plans')">💎 Plans</button>
		<button class="modal-tab" onclick="switchSubscriptionTab('billing')">💳 Billing</button>
		<button class="modal-tab" onclick="switchSubscriptionTab('churn')">📉 Churn Analysis</button>
	</div>
	
	<div id="subscriptionContent">
		<!-- Content will be loaded dynamically -->
	</div>
	`;
	
	createModal('Subscription Management', '💳', content);
	switchSubscriptionTab('overview');
}

function switchSubscriptionTab(tab) {
	// Update active tab
	document.querySelectorAll('.modal-tab').forEach(btn => btn.classList.remove('active'));
	event?.target?.classList.add('active');
	
	const contentArea = document.getElementById('subscriptionContent');
	
	switch(tab) {
		case 'overview':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">247</div>
						<div class="modal-stat-label">Active Subscriptions</div>
						<div class="modal-stat-change" style="color: var(--success);">↑ 23 this month</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$124,479</div>
						<div class="modal-stat-label">Total MRR</div>
						<div class="modal-stat-change" style="color: var(--success);">↑ 18.2% growth</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">94.7%</div>
						<div class="modal-stat-label">Retention Rate</div>
						<div class="modal-stat-change" style="color: var(--success);">Above target</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$504</div>
						<div class="modal-stat-label">ARPU</div>
						<div class="modal-stat-change" style="color: var(--primary);">Per business</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💎 Subscription Breakdown by Plan</div>
					<div style="display: grid; gap: 12px;">
						<div style="padding: 16px; background: rgba(16, 185, 129, 0.1); border-radius: 10px; border-left: 4px solid var(--success);">
							<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
								<div>
									<div style="font-size: 18px; font-weight: 700; color: var(--success);">Growth Plan</div>
									<div style="font-size: 13px; opacity: 0.7;">$199/month • Premium Features</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 24px; font-weight: 800;">42</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses</div>
								</div>
							</div>
							<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
								<div>
									<div style="font-size: 20px; font-weight: 700; color: var(--success);">$68,418</div>
									<div style="font-size: 11px; opacity: 0.7;">Monthly Revenue</div>
								</div>
								<div>
									<div style="font-size: 20px; font-weight: 700;">54.9%</div>
									<div style="font-size: 11px; opacity: 0.7;">Of Total MRR</div>
								</div>
								<div>
									<div style="font-size: 20px; font-weight: 700;">438</div>
									<div style="font-size: 11px; opacity: 0.7;">Avg Reservations</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(74, 158, 255, 0.1); border-radius: 10px; border-left: 4px solid var(--primary);">
							<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
								<div>
									<div style="font-size: 18px; font-weight: 700; color: var(--primary);">Starter Plan</div>
									<div style="font-size: 13px; opacity: 0.7;">$437/month • Standard Features</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 24px; font-weight: 800;">89</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses</div>
								</div>
							</div>
							<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
								<div>
									<div style="font-size: 20px; font-weight: 700; color: var(--primary);">$38,893</div>
									<div style="font-size: 11px; opacity: 0.7;">Monthly Revenue</div>
								</div>
								<div>
									<div style="font-size: 20px; font-weight: 700;">31.2%</div>
									<div style="font-size: 11px; opacity: 0.7;">Of Total MRR</div>
								</div>
								<div>
									<div style="font-size: 20px; font-weight: 700;">247</div>
									<div style="font-size: 11px; opacity: 0.7;">Avg Reservations</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(99, 102, 241, 0.1); border-radius: 10px; border-left: 4px solid var(--info);">
							<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
								<div>
									<div style="font-size: 18px; font-weight: 700; color: var(--info);">Starter Plan</div>
									<div style="font-size: 13px; opacity: 0.7;">$148/month • Basic Features</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 24px; font-weight: 800;">116</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses</div>
								</div>
							</div>
							<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
								<div>
									<div style="font-size: 20px; font-weight: 700; color: var(--info);">$17,168</div>
									<div style="font-size: 11px; opacity: 0.7;">Monthly Revenue</div>
								</div>
								<div>
									<div style="font-size: 20px; font-weight: 700;">13.8%</div>
									<div style="font-size: 11px; opacity: 0.7;">Of Total MRR</div>
								</div>
								<div>
									<div style="font-size: 20px; font-weight: 700;">74</div>
									<div style="font-size: 11px; opacity: 0.7;">Avg Reservations</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📈 Subscription Health Metrics</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">💚 Net Revenue Retention (NRR)</div>
							<div class="detail-item-value" style="color: var(--success);">137% <span style="opacity: 0.6; font-size: 12px;">Excellent expansion</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">📊 Quick Ratio</div>
							<div class="detail-item-value" style="color: var(--success);">6.5x <span style="opacity: 0.6; font-size: 12px;">Very healthy (>4x)</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">⏱️ Average Subscription Age</div>
							<div class="detail-item-value" style="color: var(--primary);">14.7 months <span style="opacity: 0.6; font-size: 12px;">Strong loyalty</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🎯 Trial-to-Paid Conversion</div>
							<div class="detail-item-value" style="color: var(--info);">78.5% <span style="opacity: 0.6; font-size: 12px;">Industry: 73%</span></div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Key Insights</div>
					<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• 23.4% of Starter customers upgrade within 6 months</p>
						<p style="margin-bottom: 8px;">• Growth plan has highest retention at 94.2%</p>
						<p style="margin-bottom: 8px;">• Average customer lifetime: 2.8 years ($1,697 LTV)</p>
						<p>• 34% of Growth customers purchase add-ons (avg $247/mo extra)</p>
					</div>
				</div>
			`;
			break;
			
		case 'plans':
			contentArea.innerHTML = `
				<div class="modal-section">
					<div class="modal-section-title">💎 Plan Comparison Matrix</div>
					<div style="overflow-x: auto;">
						<table style="width: 100%; border-collapse: collapse;">
							<thead>
								<tr style="background: rgba(74, 158, 255, 0.1);">
									<th style="padding: 12px; text-align: left; border: 1px solid var(--border-color);">Feature</th>
									<th style="padding: 12px; text-align: center; border: 1px solid var(--border-color);">Starter</th>
									<th style="padding: 12px; text-align: center; border: 1px solid var(--border-color);">Starter Plan</th>
									<th style="padding: 12px; text-align: center; border: 1px solid var(--border-color);">Growth Plan</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td style="padding: 10px; border: 1px solid var(--border-color);">Monthly Price</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color); font-weight: 700;">$148</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color); font-weight: 700;">$437</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color); font-weight: 700; color: var(--success);">$1,629</td>
								</tr>
								<tr style="background: rgba(255, 255, 255, 0.02);">
									<td style="padding: 10px; border: 1px solid var(--border-color);">Reservations/Month</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">150</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">500</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color); color: var(--success);">Unlimited</td>
								</tr>
								<tr>
									<td style="padding: 10px; border: 1px solid var(--border-color);">Support Level</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">Community</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">Email</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color); color: var(--success);">Priority</td>
								</tr>
								<tr style="background: rgba(255, 255, 255, 0.02);">
									<td style="padding: 10px; border: 1px solid var(--border-color);">Analytics</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">Basic</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">Standard</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color); color: var(--success);">Advanced</td>
								</tr>
								<tr>
									<td style="padding: 10px; border: 1px solid var(--border-color);">Custom Branding</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">❌</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">Limited</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color); color: var(--success);">✅ Full</td>
								</tr>
								<tr style="background: rgba(255, 255, 255, 0.02);">
									<td style="padding: 10px; border: 1px solid var(--border-color);">API Access</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">❌</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color);">❌</td>
									<td style="padding: 10px; text-align: center; border: 1px solid var(--border-color); color: var(--success);">✅</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🔄 Upgrade Path Analysis</div>
					<div style="display: grid; gap: 12px;">
						<div style="padding: 14px; background: rgba(16, 185, 129, 0.1); border-radius: 8px; border-left: 3px solid var(--success);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>✨ Starter → Growth</span>
								<strong style="color: var(--success);">23.4% upgrade rate • Avg 4.3 months</strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(74, 158, 255, 0.1); border-radius: 8px; border-left: 3px solid var(--primary);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>🚀 Starter → Growth</span>
								<strong style="color: var(--primary);">18.7% upgrade rate • Avg 7.1 months</strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(99, 102, 241, 0.1); border-radius: 8px; border-left: 3px solid var(--info);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>⚡ Starter → Growth</span>
								<strong style="color: var(--info);">8.2% direct upgrade • Avg 9.4 months</strong>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📊 Plan Performance Metrics</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">🏆 Most Popular Entry Plan</div>
							<div class="detail-item-value" style="color: var(--primary);">Starter (67% of new signups)</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">💪 Highest Retention</div>
							<div class="detail-item-value" style="color: var(--success);">Growth (94.2% retention)</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🎯 Sweet Spot Plan</div>
							<div class="detail-item-value" style="color: var(--info);">Growth (best revenue/support ratio)</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">📈 Fastest Growing</div>
							<div class="detail-item-value" style="color: var(--cyan);">Growth (+42% MoM)</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Pricing Strategy Insights</div>
					<div style="background: rgba(168, 85, 247, 0.1); border-left: 3px solid var(--purple); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Growth plan pricing is 4x Starter - optimal multiplier based on value</p>
						<p style="margin-bottom: 8px;">• 89% of customers feel pricing is "fair" or "very fair"</p>
						<p style="margin-bottom: 8px;">• Reservation limit is #1 driver for upgrades (mentioned by 67%)</p>
						<p>• Consider introducing mid-tier plan between Starter and Growth</p>
					</div>
				</div>
			`;
			break;
			
		case 'billing':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">$124,479</div>
						<div class="modal-stat-label">Current MRR</div>
						<div class="modal-stat-change" style="color: var(--success);">↑ $19,148 vs last month</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$1,493,748</div>
						<div class="modal-stat-label">ARR</div>
						<div class="modal-stat-change" style="color: var(--success);">Annual Run Rate</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">98.7%</div>
						<div class="modal-stat-label">Collection Rate</div>
						<div class="modal-stat-change" style="color: var(--success);">Payment success</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$1,624</div>
						<div class="modal-stat-label">Overdue</div>
						<div class="modal-stat-change" style="color: var(--warning);">3 accounts</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💳 Payment Method Distribution</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">💳 Credit Card</div>
							<div class="detail-item-value" style="color: var(--primary);">187 businesses <span style="opacity: 0.6; font-size: 12px;">(75.7%)</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🏦 ACH/Bank Transfer</div>
							<div class="detail-item-value" style="color: var(--success);">47 businesses <span style="opacity: 0.6; font-size: 12px;">(19.0%)</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">📄 Invoice</div>
							<div class="detail-item-value" style="color: var(--info);">13 businesses <span style="opacity: 0.6; font-size: 12px;">(5.3%)</span></div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📅 Billing Cycle Analysis</div>
					<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
						<div style="padding: 16px; background: rgba(74, 158, 255, 0.1); border-radius: 10px;">
							<div style="font-size: 18px; font-weight: 700; margin-bottom: 8px;">Monthly Billing</div>
							<div style="font-size: 32px; font-weight: 800; color: var(--primary); margin-bottom: 4px;">189</div>
							<div style="font-size: 13px; opacity: 0.7;">businesses (76.5%)</div>
							<div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border-color);">
								<div style="font-size: 20px; font-weight: 700; color: var(--success);">$95,316</div>
								<div style="font-size: 12px; opacity: 0.7;">Monthly Revenue</div>
							</div>
						</div>
						<div style="padding: 16px; background: rgba(16, 185, 129, 0.1); border-radius: 10px;">
							<div style="font-size: 18px; font-weight: 700; margin-bottom: 8px;">Annual Billing</div>
							<div style="font-size: 32px; font-weight: 800; color: var(--success); margin-bottom: 4px;">58</div>
							<div style="font-size: 13px; opacity: 0.7;">businesses (23.5%)</div>
							<div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border-color);">
								<div style="font-size: 20px; font-weight: 700; color: var(--success);">$29,163</div>
								<div style="font-size: 12px; opacity: 0.7;">Monthly Equiv. Revenue</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🎯 Revenue Concentration</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">🏢 Top 10 Customers</div>
							<div class="detail-item-value" style="color: var(--warning);">$38,247 <span style="opacity: 0.6; font-size: 12px;">30.7% of MRR</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">💼 Top 25 Customers</div>
							<div class="detail-item-value" style="color: var(--primary);">$72,184 <span style="opacity: 0.6; font-size: 12px;">58.0% of MRR</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🎯 Average Per Customer</div>
							<div class="detail-item-value" style="color: var(--info);">$504 <span style="opacity: 0.6; font-size: 12px;">ARPU</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">📊 Concentration Risk</div>
							<div class="detail-item-value" style="color: var(--success);">Low <span style="opacity: 0.6; font-size: 12px;">Well distributed</span></div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Billing Insights</div>
					<div style="background: rgba(245, 158, 11, 0.1); border-left: 3px solid var(--warning); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Annual billing customers have 42% higher retention vs monthly</p>
						<p style="margin-bottom: 8px;">• Failed payment recovery rate: 87% (recovered within 7 days)</p>
						<p style="margin-bottom: 8px;">• Average payment processing time: 2.3 seconds</p>
						<p>• Recommendation: Incentivize annual billing with 15% discount</p>
					</div>
				</div>
			`;
			break;
			
		case 'churn':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">2.8%</div>
						<div class="modal-stat-label">Monthly Churn Rate</div>
						<div class="modal-stat-change" style="color: var(--success);">↓ 0.4% vs last month</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">7</div>
						<div class="modal-stat-label">Churned This Month</div>
						<div class="modal-stat-change" style="color: var(--danger);">Lost customers</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">$3,486</div>
						<div class="modal-stat-label">MRR Lost</div>
						<div class="modal-stat-change" style="color: var(--danger);">From churn</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">94.7%</div>
						<div class="modal-stat-label">Retention Rate</div>
						<div class="modal-stat-change" style="color: var(--success);">12-month avg</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📉 Churn Reasons Analysis</div>
					<div style="display: grid; gap: 10px;">
						<div style="padding: 14px; background: rgba(239, 68, 68, 0.1); border-radius: 8px; border-left: 3px solid var(--danger);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>💰 Price/Budget Concerns</span>
								<strong style="color: var(--danger);">32% <span style="opacity: 0.6; font-size: 12px;">(9 in last 90 days)</span></strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(245, 158, 11, 0.1); border-radius: 8px; border-left: 3px solid var(--warning);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>🏪 Business Closed</span>
								<strong style="color: var(--warning);">28% <span style="opacity: 0.6; font-size: 12px;">(8 in last 90 days)</span></strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(74, 158, 255, 0.1); border-radius: 8px; border-left: 3px solid var(--primary);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>🔄 Switched to Competitor</span>
								<strong style="color: var(--primary);">18% <span style="opacity: 0.6; font-size: 12px;">(5 in last 90 days)</span></strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(99, 102, 241, 0.1); border-radius: 8px; border-left: 3px solid var(--info);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>⚙️ Feature Limitations</span>
								<strong style="color: var(--info);">14% <span style="opacity: 0.6; font-size: 12px;">(4 in last 90 days)</span></strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(255, 255, 255, 0.05); border-radius: 8px; border-left: 3px solid var(--text-tertiary);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>❓ Other/Unknown</span>
								<strong>8% <span style="opacity: 0.6; font-size: 12px;">(2 in last 90 days)</span></strong>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🎯 Churn Risk Indicators</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">⚠️ High Risk (Likely to Churn)</div>
							<div class="detail-item-value" style="color: var(--danger);">12 businesses <span style="opacity: 0.6; font-size: 12px;">Action needed</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🟡 Medium Risk</div>
							<div class="detail-item-value" style="color: var(--warning);">28 businesses <span style="opacity: 0.6; font-size: 12px;">Monitor closely</span></div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🟢 Low Risk (Healthy)</div>
							<div class="detail-item-value" style="color: var(--success);">207 businesses <span style="opacity: 0.6; font-size: 12px;">83.8% stable</span></div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📊 Churn by Plan Type</div>
					<div style="display: grid; gap: 12px;">
						<div style="display: flex; justify-content: space-between; padding: 12px; background: rgba(99, 102, 241, 0.1); border-radius: 8px;">
							<span>Starter Plan</span>
							<strong style="color: var(--info);">4.2% churn <span style="opacity: 0.6; font-size: 12px;">(Highest)</span></strong>
						</div>
						<div style="display: flex; justify-content: space-between; padding: 12px; background: rgba(74, 158, 255, 0.08); border-radius: 8px;">
							<span>Starter Plan</span>
							<strong style="color: var(--primary);">2.6% churn <span style="opacity: 0.6; font-size: 12px;">(Average)</span></strong>
						</div>
						<div style="display: flex; justify-content: space-between; padding: 12px; background: rgba(16, 185, 129, 0.1); border-radius: 8px;">
							<span>Growth Plan</span>
							<strong style="color: var(--success);">0.8% churn <span style="opacity: 0.6; font-size: 12px;">(Lowest)</span></strong>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Churn Prevention Insights</div>
					<div style="background: rgba(239, 68, 68, 0.1); border-left: 3px solid var(--danger); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Customers with <10 reservations/month churn 3.8x more</p>
						<p style="margin-bottom: 8px;">• 67% of churned customers never contacted support</p>
						<p style="margin-bottom: 8px;">• Usage dropped 40%+ before churn in 78% of cases</p>
						<p>• Recommendation: Implement proactive outreach for low-engagement users</p>
					</div>
				</div>
			`;
			break;
	}
}

function viewGeographicDistribution() {
	const content = `
	<div class="modal-tabs">
		<button class="modal-tab active" onclick="switchGeoTab('overview')">🌍 Overview</button>
		<button class="modal-tab" onclick="switchGeoTab('regions')">📍 By Region</button>
		<button class="modal-tab" onclick="switchGeoTab('cities')">🏙️ Top Cities</button>
		<button class="modal-tab" onclick="switchGeoTab('performance')">📊 Performance</button>
	</div>
	
	<div id="geoContent">
		<!-- Content will be loaded dynamically -->
	</div>
	`;
	
	createModal('Geographic Distribution', '🌍', content);
	switchGeoTab('overview');
}

function switchGeoTab(tab) {
	// Update active tab
	document.querySelectorAll('.modal-tab').forEach(btn => btn.classList.remove('active'));
	event?.target?.classList.add('active');
	
	const contentArea = document.getElementById('geoContent');
	
	switch(tab) {
		case 'overview':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">42</div>
						<div class="modal-stat-label">States</div>
						<div class="modal-stat-change" style="color: var(--primary);">US Coverage</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">3</div>
						<div class="modal-stat-label">Countries</div>
						<div class="modal-stat-change" style="color: var(--info);">International</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">127</div>
						<div class="modal-stat-label">Cities</div>
						<div class="modal-stat-change" style="color: var(--success);">Active Markets</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">247</div>
						<div class="modal-stat-label">Total Businesses</div>
						<div class="modal-stat-change" style="color: var(--primary);">Nationwide</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🌎 Geographic Distribution Map</div>
					<div style="background: rgba(255, 255, 255, 0.02); padding: 20px; border-radius: 10px; text-align: center;">
						<div style="font-size: 120px; margin: 20px 0;">🗺️</div>
						<div style="font-size: 18px; font-weight: 600; margin-bottom: 8px;">Interactive Map View</div>
						<div style="font-size: 14px; opacity: 0.7;">Heat map showing business concentration across regions</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🇺🇸 Country Breakdown</div>
					<div style="display: grid; gap: 12px;">
						<div style="padding: 16px; background: rgba(74, 158, 255, 0.15); border-radius: 10px; border-left: 4px solid var(--primary);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<div>
									<div style="font-size: 20px; font-weight: 700; margin-bottom: 4px;">🇺🇸 United States</div>
									<div style="font-size: 13px; opacity: 0.7;">Primary Market</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 32px; font-weight: 800; color: var(--primary);">234</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses (94.7%)</div>
								</div>
							</div>
							<div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid rgba(255,255,255,0.1);">
								<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
									<div>
										<div style="font-size: 18px; font-weight: 700; color: var(--success);">$118,247</div>
										<div style="font-size: 11px; opacity: 0.7;">MRR</div>
									</div>
									<div>
										<div style="font-size: 18px; font-weight: 700;">$505</div>
										<div style="font-size: 11px; opacity: 0.7;">Avg ARPU</div>
									</div>
									<div>
										<div style="font-size: 18px; font-weight: 700;">233K</div>
										<div style="font-size: 11px; opacity: 0.7;">Reservations</div>
									</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(16, 185, 129, 0.1); border-radius: 10px; border-left: 4px solid var(--success);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<div>
									<div style="font-size: 20px; font-weight: 700; margin-bottom: 4px;">🇨🇦 Canada</div>
									<div style="font-size: 13px; opacity: 0.7;">International Growth</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 32px; font-weight: 800; color: var(--success);">11</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses (4.5%)</div>
								</div>
							</div>
							<div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid rgba(255,255,255,0.1);">
								<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
									<div>
										<div style="font-size: 18px; font-weight: 700; color: var(--success);">$5,324</div>
										<div style="font-size: 11px; opacity: 0.7;">MRR</div>
									</div>
									<div>
										<div style="font-size: 18px; font-weight: 700;">$484</div>
										<div style="font-size: 11px; opacity: 0.7;">Avg ARPU</div>
									</div>
									<div>
										<div style="font-size: 18px; font-weight: 700;">11.2K</div>
										<div style="font-size: 11px; opacity: 0.7;">Reservations</div>
									</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(99, 102, 241, 0.1); border-radius: 10px; border-left: 4px solid var(--info);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<div>
									<div style="font-size: 20px; font-weight: 700; margin-bottom: 4px;">🇬🇧 United Kingdom</div>
									<div style="font-size: 13px; opacity: 0.7;">European Expansion</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 32px; font-weight: 800; color: var(--info);">2</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses (0.8%)</div>
								</div>
							</div>
							<div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid rgba(255,255,255,0.1);">
								<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
									<div>
										<div style="font-size: 18px; font-weight: 700; color: var(--info);">$908</div>
										<div style="font-size: 11px; opacity: 0.7;">MRR</div>
									</div>
									<div>
										<div style="font-size: 18px; font-weight: 700;">$454</div>
										<div style="font-size: 11px; opacity: 0.7;">Avg ARPU</div>
									</div>
									<div>
										<div style="font-size: 18px; font-weight: 700;">2.8K</div>
										<div style="font-size: 11px; opacity: 0.7;">Reservations</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Geographic Insights</div>
					<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Top 5 states account for 47% of total customers</p>
						<p style="margin-bottom: 8px;">• Urban areas have 2.3x higher ARPU than rural markets</p>
						<p style="margin-bottom: 8px;">• International growth: +340% YoY (from 3 to 13 businesses)</p>
						<p>• Expansion opportunity: Major metros in TX, FL, and AZ underserved</p>
					</div>
				</div>
			`;
			break;
			
		case 'regions':
			contentArea.innerHTML = `
				<div class="modal-section">
					<div class="modal-section-title">🗺️ US Regional Distribution</div>
					<div style="display: grid; gap: 12px;">
						<div style="padding: 16px; background: rgba(74, 158, 255, 0.12); border-radius: 10px; border-left: 4px solid var(--primary);">
							<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
								<div>
									<div style="font-size: 18px; font-weight: 700;">🌆 West Coast</div>
									<div style="font-size: 13px; opacity: 0.7;">CA, OR, WA</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 28px; font-weight: 800; color: var(--primary);">89</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses</div>
								</div>
							</div>
							<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
								<div>
									<div style="font-size: 16px; font-weight: 700; color: var(--success);">$48,247</div>
									<div style="font-size: 10px; opacity: 0.7;">MRR</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">38.1%</div>
									<div style="font-size: 10px; opacity: 0.7;">Market Share</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">$542</div>
									<div style="font-size: 10px; opacity: 0.7;">ARPU</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">95.2%</div>
									<div style="font-size: 10px; opacity: 0.7;">Retention</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(16, 185, 129, 0.1); border-radius: 10px; border-left: 4px solid var(--success);">
							<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
								<div>
									<div style="font-size: 18px; font-weight: 700;">🗽 Northeast</div>
									<div style="font-size: 13px; opacity: 0.7;">NY, MA, PA, NJ</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 28px; font-weight: 800; color: var(--success);">62</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses</div>
								</div>
							</div>
							<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
								<div>
									<div style="font-size: 16px; font-weight: 700; color: var(--success);">$34,186</div>
									<div style="font-size: 10px; opacity: 0.7;">MRR</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">26.5%</div>
									<div style="font-size: 10px; opacity: 0.7;">Market Share</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">$551</div>
									<div style="font-size: 10px; opacity: 0.7;">ARPU</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">96.8%</div>
									<div style="font-size: 10px; opacity: 0.7;">Retention</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(245, 158, 11, 0.1); border-radius: 10px; border-left: 4px solid var(--warning);">
							<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
								<div>
									<div style="font-size: 18px; font-weight: 700;">🌴 Southeast</div>
									<div style="font-size: 13px; opacity: 0.7;">FL, GA, NC, SC</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 28px; font-weight: 800; color: var(--warning);">47</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses</div>
								</div>
							</div>
							<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
								<div>
									<div style="font-size: 16px; font-weight: 700; color: var(--warning);">$21,328</div>
									<div style="font-size: 10px; opacity: 0.7;">MRR</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">20.1%</div>
									<div style="font-size: 10px; opacity: 0.7;">Market Share</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">$454</div>
									<div style="font-size: 10px; opacity: 0.7;">ARPU</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">92.3%</div>
									<div style="font-size: 10px; opacity: 0.7;">Retention</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(99, 102, 241, 0.1); border-radius: 10px; border-left: 4px solid var(--info);">
							<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
								<div>
									<div style="font-size: 18px; font-weight: 700;">🌾 Midwest</div>
									<div style="font-size: 13px; opacity: 0.7;">IL, OH, MI, MN</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 28px; font-weight: 800; color: var(--info);">24</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses</div>
								</div>
							</div>
							<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
								<div>
									<div style="font-size: 16px; font-weight: 700; color: var(--info);">$10,248</div>
									<div style="font-size: 10px; opacity: 0.7;">MRR</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">10.3%</div>
									<div style="font-size: 10px; opacity: 0.7;">Market Share</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">$427</div>
									<div style="font-size: 10px; opacity: 0.7;">ARPU</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">94.1%</div>
									<div style="font-size: 10px; opacity: 0.7;">Retention</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(168, 85, 247, 0.1); border-radius: 10px; border-left: 4px solid var(--purple);">
							<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
								<div>
									<div style="font-size: 18px; font-weight: 700;">🏜️ Southwest</div>
									<div style="font-size: 13px; opacity: 0.7;">TX, AZ, NV, CO</div>
								</div>
								<div style="text-align: right;">
									<div style="font-size: 28px; font-weight: 800; color: var(--purple);">12</div>
									<div style="font-size: 12px; opacity: 0.7;">businesses</div>
								</div>
							</div>
							<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
								<div>
									<div style="font-size: 16px; font-weight: 700; color: var(--purple);">$4,238</div>
									<div style="font-size: 10px; opacity: 0.7;">MRR</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">5.1%</div>
									<div style="font-size: 10px; opacity: 0.7;">Market Share</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">$353</div>
									<div style="font-size: 10px; opacity: 0.7;">ARPU</div>
								</div>
								<div>
									<div style="font-size: 16px; font-weight: 700;">91.7%</div>
									<div style="font-size: 10px; opacity: 0.7;">Retention</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📈 Regional Growth Trends</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">🚀 Fastest Growing</div>
							<div class="detail-item-value" style="color: var(--success);">Southeast (+67% YoY)</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">💪 Highest ARPU</div>
							<div class="detail-item-value" style="color: var(--primary);">Northeast ($551)</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🏆 Best Retention</div>
							<div class="detail-item-value" style="color: var(--info);">Northeast (96.8%)</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🎯 Expansion Target</div>
							<div class="detail-item-value" style="color: var(--warning);">Southwest (untapped potential)</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Regional Insights</div>
					<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• West Coast and Northeast together represent 64.6% of total revenue</p>
						<p style="margin-bottom: 8px;">• Coastal regions have 28% higher ARPU than inland markets</p>
						<p style="margin-bottom: 8px;">• Southwest showing promising 34% MoM growth despite small base</p>
						<p>• Recommendation: Focus sales efforts on major Southwest metros (Austin, Phoenix, Denver)</p>
					</div>
				</div>
			`;
			break;
			
		case 'cities':
			contentArea.innerHTML = `
				<div class="modal-section">
					<div class="modal-section-title">🏙️ Top 15 Cities by Customer Count</div>
					<div style="display: grid; gap: 8px;">
						${[
							{ city: 'San Francisco, CA', count: 23, mrr: '$14,892', arpu: '$648' },
							{ city: 'New York, NY', count: 19, mrr: '$11,743', arpu: '$618' },
							{ city: 'Los Angeles, CA', count: 17, mrr: '$9,384', arpu: '$552' },
							{ city: 'Seattle, WA', count: 14, mrr: '$7,896', arpu: '$564' },
							{ city: 'Boston, MA', count: 12, mrr: '$7,248', arpu: '$604' },
							{ city: 'Chicago, IL', count: 11, mrr: '$5,247', arpu: '$477' },
							{ city: 'Miami, FL', count: 9, mrr: '$4,293', arpu: '$477' },
							{ city: 'Austin, TX', count: 8, mrr: '$3,584', arpu: '$448' },
							{ city: 'Portland, OR', count: 7, mrr: '$3,766', arpu: '$538' },
							{ city: 'Denver, CO', count: 6, mrr: '$2,694', arpu: '$449' },
							{ city: 'Atlanta, GA', count: 6, mrr: '$2,514', arpu: '$419' },
							{ city: 'San Diego, CA', count: 5, mrr: '$2,945', arpu: '$589' },
							{ city: 'Philadelphia, PA', count: 5, mrr: '$2,475', arpu: '$495' },
							{ city: 'Phoenix, AZ', count: 4, mrr: '$1,596', arpu: '$399' },
							{ city: 'Nashville, TN', count: 4, mrr: '$1,732', arpu: '$433' }
						].map((item, index) => `
							<div style="padding: 14px; background: rgba(74, 158, 255, ${0.12 - index * 0.007}); border-radius: 8px; display: flex; justify-content: space-between; align-items: center;">
								<div style="display: flex; align-items: center; gap: 12px; flex: 1;">
									<div style="font-size: 20px; font-weight: 800; color: ${index < 3 ? 'var(--success)' : 'var(--text-secondary)'}; width: 32px;">#${index + 1}</div>
									<div style="flex: 1;">
										<div style="font-size: 15px; font-weight: 600;">${item.city}</div>
										<div style="font-size: 12px; opacity: 0.7;">${item.count} businesses</div>
									</div>
								</div>
								<div style="display: flex; gap: 20px; text-align: right;">
									<div>
										<div style="font-size: 16px; font-weight: 700; color: var(--success);">${item.mrr}</div>
										<div style="font-size: 10px; opacity: 0.7;">MRR</div>
									</div>
									<div>
										<div style="font-size: 16px; font-weight: 700;">${item.arpu}</div>
										<div style="font-size: 10px; opacity: 0.7;">ARPU</div>
									</div>
								</div>
							</div>
						`).join('')}
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🎯 Market Opportunity Analysis</div>
					<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
						<div style="padding: 16px; background: rgba(16, 185, 129, 0.1); border-radius: 10px;">
							<div style="font-size: 16px; font-weight: 700; margin-bottom: 12px; color: var(--success);">🔥 Hot Markets</div>
							<div style="display: grid; gap: 8px;">
								<div style="padding: 8px; background: rgba(255,255,255,0.05); border-radius: 6px;">
									<div style="font-weight: 600;">San Francisco</div>
									<div style="font-size: 11px; opacity: 0.7;">+6 new businesses this quarter</div>
								</div>
								<div style="padding: 8px; background: rgba(255,255,255,0.05); border-radius: 6px;">
									<div style="font-weight: 600;">Austin</div>
									<div style="font-size: 11px; opacity: 0.7;">+4 new businesses this quarter</div>
								</div>
								<div style="padding: 8px; background: rgba(255,255,255,0.05); border-radius: 6px;">
									<div style="font-weight: 600;">Miami</div>
									<div style="font-size: 11px; opacity: 0.7;">+3 new businesses this quarter</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(245, 158, 11, 0.1); border-radius: 10px;">
							<div style="font-size: 16px; font-weight: 700; margin-bottom: 12px; color: var(--warning);">🎯 Untapped Markets</div>
							<div style="display: grid; gap: 8px;">
								<div style="padding: 8px; background: rgba(255,255,255,0.05); border-radius: 6px;">
									<div style="font-weight: 600;">Dallas, TX</div>
									<div style="font-size: 11px; opacity: 0.7;">Only 2 businesses, high potential</div>
								</div>
								<div style="padding: 8px; background: rgba(255,255,255,0.05); border-radius: 6px;">
									<div style="font-weight: 600;">Houston, TX</div>
									<div style="font-size: 11px; opacity: 0.7;">Only 1 business, untapped market</div>
								</div>
								<div style="padding: 8px; background: rgba(255,255,255,0.05); border-radius: 6px;">
									<div style="font-weight: 600;">Charlotte, NC</div>
									<div style="font-size: 11px; opacity: 0.7;">Zero presence, growing restaurant scene</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 City Market Insights</div>
					<div style="background: rgba(99, 102, 241, 0.1); border-left: 3px solid var(--info); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Top 3 cities (SF, NY, LA) represent 25% of total customer base</p>
						<p style="margin-bottom: 8px;">• San Francisco has highest ARPU at $648 (29% above average)</p>
						<p style="margin-bottom: 8px;">• Coastal cities outperform inland markets by 36% in ARPU</p>
						<p>• Major Texas cities are underserved with strong expansion potential</p>
					</div>
				</div>
			`;
			break;
			
		case 'performance':
			contentArea.innerHTML = `
				<div class="modal-stats-grid">
					<div class="modal-stat-card">
						<div class="modal-stat-value">$648</div>
						<div class="modal-stat-label">Highest ARPU</div>
						<div class="modal-stat-change" style="color: var(--success);">San Francisco, CA</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">96.8%</div>
						<div class="modal-stat-label">Best Retention</div>
						<div class="modal-stat-change" style="color: var(--success);">Northeast Region</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">+67%</div>
						<div class="modal-stat-label">Fastest Growth</div>
						<div class="modal-stat-change" style="color: var(--primary);">Southeast YoY</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value">247K</div>
						<div class="modal-stat-label">Total Reservations</div>
						<div class="modal-stat-change" style="color: var(--info);">Across all markets</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🏆 Top Performing Markets</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">💎 Highest Revenue per Market</div>
							<div class="detail-item-value" style="color: var(--success);">San Francisco - $14,892 MRR</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">📈 Highest Growth Rate</div>
							<div class="detail-item-value" style="color: var(--primary);">Miami - +87% YoY</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">🎯 Best Customer Density</div>
							<div class="detail-item-value" style="color: var(--info);">San Francisco - 23 per 100K pop</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">⭐ Highest Satisfaction</div>
							<div class="detail-item-value" style="color: var(--warning);">Boston - 4.9/5.0 avg rating</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📊 Performance Comparison: Urban vs. Rural</div>
					<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
						<div style="padding: 16px; background: rgba(74, 158, 255, 0.1); border-radius: 10px;">
							<div style="font-size: 18px; font-weight: 700; margin-bottom: 12px; color: var(--primary);">🏙️ Urban Markets</div>
							<div style="display: grid; gap: 10px;">
								<div>
									<div style="font-size: 24px; font-weight: 800; color: var(--success);">$573</div>
									<div style="font-size: 12px; opacity: 0.7;">Average ARPU</div>
								</div>
								<div>
									<div style="font-size: 24px; font-weight: 800;">95.4%</div>
									<div style="font-size: 12px; opacity: 0.7;">Retention Rate</div>
								</div>
								<div>
									<div style="font-size: 24px; font-weight: 800;">402</div>
									<div style="font-size: 12px; opacity: 0.7;">Avg Reservations/mo</div>
								</div>
								<div style="margin-top: 8px; padding-top: 8px; border-top: 1px solid rgba(255,255,255,0.1);">
									<div style="font-size: 14px; opacity: 0.8;">203 businesses (82%)</div>
								</div>
							</div>
						</div>
						
						<div style="padding: 16px; background: rgba(16, 185, 129, 0.1); border-radius: 10px;">
							<div style="font-size: 18px; font-weight: 700; margin-bottom: 12px; color: var(--success);">🌾 Rural Markets</div>
							<div style="display: grid; gap: 10px;">
								<div>
									<div style="font-size: 24px; font-weight: 800;">$249</div>
									<div style="font-size: 12px; opacity: 0.7;">Average ARPU</div>
								</div>
								<div>
									<div style="font-size: 24px; font-weight: 800;">93.1%</div>
									<div style="font-size: 12px; opacity: 0.7;">Retention Rate</div>
								</div>
								<div>
									<div style="font-size: 24px; font-weight: 800;">156</div>
									<div style="font-size: 12px; opacity: 0.7;">Avg Reservations/mo</div>
								</div>
								<div style="margin-top: 8px; padding-top: 8px; border-top: 1px solid rgba(255,255,255,0.1);">
									<div style="font-size: 14px; opacity: 0.8;">44 businesses (18%)</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🎯 Market Saturation Analysis</div>
					<div style="display: grid; gap: 10px;">
						<div style="padding: 14px; background: rgba(16, 185, 129, 0.1); border-radius: 8px; border-left: 3px solid var(--success);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>✅ Low Saturation (High Opportunity)</span>
								<strong style="color: var(--success);">42 markets</strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(245, 158, 11, 0.1); border-radius: 8px; border-left: 3px solid var(--warning);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>⚠️ Medium Saturation</span>
								<strong style="color: var(--warning);">68 markets</strong>
							</div>
						</div>
						<div style="padding: 14px; background: rgba(239, 68, 68, 0.1); border-radius: 8px; border-left: 3px solid var(--danger);">
							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span>🔴 High Saturation (Competitive)</span>
								<strong style="color: var(--danger);">17 markets</strong>
							</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">💡 Performance Insights</div>
					<div style="background: rgba(168, 85, 247, 0.1); border-left: 3px solid var(--purple); padding: 16px; border-radius: 8px;">
						<p style="margin-bottom: 8px;">• Urban markets generate 2.3x more revenue per customer than rural areas</p>
						<p style="margin-bottom: 8px;">• Markets with 5+ competitors show 18% lower ARPU but 12% higher retention</p>
						<p style="margin-bottom: 8px;">• Tourist destination cities (Miami, SF, NYC) have 34% higher reservation volumes</p>
						<p>• Secondary cities (Austin, Denver, Nashville) showing strongest growth potential</p>
					</div>
				</div>
			`;
			break;
	}
}

function setChartPeriod(period) {
dashboardState.chartPeriod = period;
document.querySelectorAll('.chart-btn').forEach(btn => btn.classList.remove('active'));
event.target.classList.add('active');
showToast(`Updated chart to show ${period} data`, 'info');
createRevenueChart();
}

// ==================== REALTIME UPDATES ====================
function startRealtimeUpdates() {
setInterval(() => {
const activityTypes = [
{ icon: '📅', text: 'created a reservation', color: '--primary' },
{ icon: '✅', text: 'checked in a customer', color: '--info' },
{ icon: '⚙️', text: 'updated business settings', color: '--warning' }
];

const business = dashboardState.businesses[Math.floor(Math.random() * Math.min(10, dashboardState.businesses.length))];
const activity = activityTypes[Math.floor(Math.random() * activityTypes.length)];

dashboardState.activities.unshift({
icon: activity.icon,
text: `${business.name} ${activity.text}`,
time: 'Just now',
location: business.owner,
color: activity.color
});

if (dashboardState.activities.length > 20) {
dashboardState.activities.pop();
}

renderActivityFeed();
}, 10000);

setInterval(() => {
dashboardState.activities.forEach(activity => {
if (activity.time === 'Just now') {
activity.time = '1 minute ago';
} else if (activity.time.includes('minute')) {
const minutes = parseInt(activity.time) + 1;
activity.time = minutes < 60 ? `${minutes} minutes ago` : '1 hour ago';
}
});
renderActivityFeed();
}, 60000);
}

// ==================== TOAST NOTIFICATIONS ====================
function showToast(message, type = 'info') {
const colors = {
info: '#4a9eff',
success: '#10b981',
warning: '#f59e0b',
danger: '#ef4444'
};

const toast = document.createElement('div');
toast.style.cssText = `
position: fixed;
bottom: 30px;
right: 30px;
background: var(--bg-card);
border: 1px solid ${colors[type]};
border-left: 4px solid ${colors[type]};
padding: 16px 20px;
border-radius: 8px;
box-shadow: 0 8px 30px rgba(0, 0, 0, 0.4);
color: var(--text-primary);
font-size: 13px;
font-weight: 600;
z-index: 10000;
animation: slideIn 0.3s ease-out;
backdrop-filter: blur(10px);
max-width: 400px;
`;

toast.textContent = message;
document.body.appendChild(toast);

setTimeout(() => {
toast.style.animation = 'slideOut 0.3s ease-out';
setTimeout(() => toast.remove(), 300);
}, 3000);
}

const style = document.createElement('style');
style.textContent = `
@keyframes slideIn {
from {
transform: translateX(400px);
opacity: 0;
}
to {
transform: translateX(0);
opacity: 1;
}
}
@keyframes slideOut {
from {
transform: translateX(0);
opacity: 1;
}
to {
transform: translateX(400px);
opacity: 0;
}
}
`;
document.head.appendChild(style);

// ==================== SEARCH AND FILTER ====================
document.getElementById('searchBusinesses')?.addEventListener('input', (e) => {
const searchTerm = e.target.value.toLowerCase();
const filteredBusinesses = dashboardState.businesses.filter(business =>
business.name.toLowerCase().includes(searchTerm) ||
business.owner.toLowerCase().includes(searchTerm)
);
renderFilteredBusinessTable(filteredBusinesses);
});

document.getElementById('filterStatus')?.addEventListener('change', (e) => {
const status = e.target.value;
const filteredBusinesses = status === 'all'
? dashboardState.businesses
: dashboardState.businesses.filter(business => business.status === status);
renderFilteredBusinessTable(filteredBusinesses);
});

function renderFilteredBusinessTable(businesses) {
const tbody = document.getElementById('businessTable');
tbody.innerHTML = businesses.map(business => `
<tr onclick="showBusinessDetailsModal(${business.id})" style="cursor: pointer;">
<td>
<div style="display: flex; align-items: center; gap: 10px;">
<div style="width: 36px; height: 36px; border-radius: 8px; background: linear-gradient(135deg, var(--primary), var(--purple)); display: flex; align-items: center; justify-content: center; font-weight: 700;">
${business.name.charAt(0)}
</div>
<strong>${business.name}</strong>
</div>
</td>
<td>${business.owner}</td>
<td><span class="badge badge-primary">${business.plan}</span></td>
<td><span class="status-badge status-${business.status}">${business.status}</span></td>
<td>${business.template}</td>
<td><strong>${business.reservations}</strong></td>
<td><strong style="color: var(--success);">$${business.revenue}</strong></td>
<td>${business.joinDate}</td>
<td>
<button style="padding: 6px 12px; background: var(--primary); border: none; border-radius: 6px; color: white; cursor: pointer; font-size: 11px; font-weight: 600;" onclick="event.stopPropagation(); showBusinessDetailsModal(${business.id})">
View Details
</button>
</td>
</tr>
`).join('');
}

// ==================== INITIALIZE ON LOAD ====================
window.addEventListener('DOMContentLoaded', initializeDashboard);

// ==================== SIDEBAR FUNCTIONS ====================
function toggleSidebar() {
	const sidebar = document.getElementById('leftSidebar');
	const overlay = document.getElementById('sidebarOverlay');
	sidebar.classList.toggle('open');
	overlay.classList.toggle('active');
}

function navigateTo(section, event) {
	if (event) event.preventDefault();
	
	// Update active link
	document.querySelectorAll('.sidebar-link').forEach(link => {
		link.classList.remove('active');
	});
	event.currentTarget.classList.add('active');
	
	// Hide all sections
	document.querySelectorAll('.content-section').forEach(sec => {
		sec.classList.remove('active');
	});
	
	// Show the target section
	const targetSection = document.getElementById('section-' + section);
	if (targetSection) {
		targetSection.classList.add('active');
	}
	
	// Close sidebar on mobile
	if (window.innerWidth <= 1024) {
		toggleSidebar();
	}
	
	// Initialize section data
	initializeSectionData(section);
	
	// Scroll to top
	window.scrollTo({ top: 0, behavior: 'smooth' });
}

function initializeSectionData(section) {
	switch(section) {
		case 'businesses':
			populateBusinessesSection();
			break;
		case 'reservations':
			populateReservationsSection();
			break;
		case 'customers':
			populateCustomersSection();
			break;
		case 'revenue':
			populateRevenueSection();
			break;
		case 'analytics':
			populateAnalyticsSection();
			break;
		case 'reports':
			populateReportsSection();
			break;
		case 'markets':
			populateMarketsSection();
			break;
		case 'users':
			populateUsersSection();
			break;
		case 'templates':
			populateTemplatesSection();
			break;
		case 'marketing':
			populateMarketingSection();
			break;
		case 'support':
			populateSupportSection();
			break;
		case 'integrations':
			populateIntegrationsSection();
			break;
		case 'system':
			populateSystemSection();
			break;
		case 'logs':
			populateLogsSection();
			break;
	}
}

// ==================== SECTION DATA POPULATION ====================

function populateBusinessesSection() {
	const tbody = document.getElementById('businessTableSection');
	if (!tbody) return;
	
	tbody.innerHTML = dashboardState.businesses.map(business => `
		<tr onclick="showBusinessDetailsModal(${business.id})" style="cursor: pointer;">
			<td>
				<div style="display: flex; align-items: center; gap: 10px;">
					<div style="width: 36px; height: 36px; border-radius: 8px; background: linear-gradient(135deg, var(--primary), var(--purple)); display: flex; align-items: center; justify-content: center; font-weight: 700;">
						${business.name.charAt(0)}
					</div>
					<strong>${business.name}</strong>
				</div>
			</td>
			<td>${business.owner}</td>
			<td><span class="badge badge-primary">${business.plan}</span></td>
			<td><span class="status-badge status-${business.status}">${business.status}</span></td>
			<td>${business.template}</td>
			<td><strong>${business.reservations}</strong></td>
			<td><strong style="color: var(--success);">$${business.revenue}</strong></td>
			<td>${business.joinDate}</td>
			<td>
				<button style="padding: 6px 12px; background: var(--primary); border: none; border-radius: 6px; color: white; cursor: pointer; font-size: 11px; font-weight: 600;" onclick="event.stopPropagation(); showBusinessDetailsModal(${business.id})">
					View
				</button>
			</td>
		</tr>
	`).join('');
}

function populateReservationsSection() {
	const tbody = document.getElementById('reservationsTableBody');
	if (!tbody) return;
	
	const reservations = generateReservationsData();
	tbody.innerHTML = reservations.map(res => `
		<tr>
			<td><strong>#${res.id}</strong></td>
			<td>${res.business}</td>
			<td>${res.customer}</td>
			<td>${res.dateTime}</td>
			<td>${res.partySize}</td>
			<td><span class="status-badge status-${res.status}">${res.status}</span></td>
			<td>${res.source}</td>
		</tr>
	`).join('');
}

function populateCustomersSection() {
	const tbody = document.getElementById('customersTableBody');
	if (!tbody) return;
	
	const customers = generateCustomersData();
	tbody.innerHTML = customers.map(cust => `
		<tr>
			<td>
				<div style="display: flex; align-items: center; gap: 10px;">
					<div style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, var(--info), var(--cyan)); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 12px;">
						${cust.name.split(' ').map(n => n[0]).join('')}
					</div>
					<strong>${cust.name}</strong>
				</div>
			</td>
			<td>${cust.email}</td>
			<td>${cust.phone}</td>
			<td><strong>${cust.visits}</strong></td>
			<td>${cust.lastVisit}</td>
			<td>${cust.favorite}</td>
			<td><span class="status-badge status-${cust.status}">${cust.status}</span></td>
		</tr>
	`).join('');
}

function populateRevenueSection() {
	const tbody = document.getElementById('transactionsTableBody');
	if (!tbody) return;
	
	const transactions = generateTransactionsData();
	tbody.innerHTML = transactions.map(tx => `
		<tr>
			<td><strong>#${tx.id}</strong></td>
			<td>${tx.business}</td>
			<td><strong style="color: var(--success);">$${tx.amount}</strong></td>
			<td>${tx.type}</td>
			<td><span class="status-badge status-${tx.status}">${tx.statusLabel}</span></td>
			<td>${tx.date}</td>
			<td>${tx.method}</td>
		</tr>
	`).join('');
}

function populateAnalyticsSection() {
	const featuresList = document.getElementById('topFeaturesList');
	const devicesList = document.getElementById('deviceBreakdownList');
	
	if (featuresList) {
		featuresList.innerHTML = `
			<div class="detail-item"><div class="detail-item-label">📅 Reservation Booking</div><div class="detail-item-value">89% usage</div></div>
			<div class="detail-item"><div class="detail-item-label">📋 Waitlist Management</div><div class="detail-item-value">76% usage</div></div>
			<div class="detail-item"><div class="detail-item-label">📊 Analytics Dashboard</div><div class="detail-item-value">68% usage</div></div>
			<div class="detail-item"><div class="detail-item-label">📧 SMS Notifications</div><div class="detail-item-value">62% usage</div></div>
			<div class="detail-item"><div class="detail-item-label">🗺️ Floor Plan Editor</div><div class="detail-item-value">45% usage</div></div>
		`;
	}
	
	if (devicesList) {
		devicesList.innerHTML = `
			<div class="detail-item"><div class="detail-item-label">📱 Mobile</div><div class="detail-item-value">62%</div></div>
			<div class="detail-item"><div class="detail-item-label">💻 Desktop</div><div class="detail-item-value">31%</div></div>
			<div class="detail-item"><div class="detail-item-label">📟 Tablet</div><div class="detail-item-value">7%</div></div>
		`;
	}
}

function populateReportsSection() {
	const recentList = document.getElementById('recentReportsList');
	const scheduledList = document.getElementById('scheduledReportsList');
	const historyTable = document.getElementById('reportHistoryTableBody');
	
	if (recentList) {
		recentList.innerHTML = `
			<div class="detail-item"><div class="detail-item-label">💰 Monthly Revenue Report</div><div class="detail-item-value">Generated 2h ago</div></div>
			<div class="detail-item"><div class="detail-item-label">📅 Reservations Summary</div><div class="detail-item-value">Generated 1d ago</div></div>
			<div class="detail-item"><div class="detail-item-label">🏢 Business Health Check</div><div class="detail-item-value">Generated 2d ago</div></div>
		`;
	}
	
	if (scheduledList) {
		scheduledList.innerHTML = `
			<div class="detail-item"><div class="detail-item-label">📊 Weekly Summary</div><div class="detail-item-value">Every Monday 9am</div></div>
			<div class="detail-item"><div class="detail-item-label">💰 Monthly Revenue</div><div class="detail-item-value">1st of month</div></div>
			<div class="detail-item"><div class="detail-item-label">📈 Quarterly Review</div><div class="detail-item-value">End of quarter</div></div>
		`;
	}
	
	if (historyTable) {
		const reports = generateReportsData();
		historyTable.innerHTML = reports.map(r => `
			<tr>
				<td><strong>${r.name}</strong></td>
				<td>${r.type}</td>
				<td>${r.range}</td>
				<td>${r.generated}</td>
				<td>${r.size}</td>
				<td>
					<button class="action-btn" style="padding: 6px 12px; font-size: 11px;" onclick="downloadReport('${r.id}')">📥 Download</button>
				</td>
			</tr>
		`).join('');
	}
}

function populateMarketsSection() {
	const topMarkets = document.getElementById('topMarketsList');
	const growingMarkets = document.getElementById('growingMarketsList');
	const marketsTable = document.getElementById('marketsTableBody');
	
	if (topMarkets) {
		topMarkets.innerHTML = `
			<div class="detail-item"><div class="detail-item-label">🗽 New York, NY</div><div class="detail-item-value" style="color: var(--success);">$18.4K MRR</div></div>
			<div class="detail-item"><div class="detail-item-label">🌉 San Francisco, CA</div><div class="detail-item-value" style="color: var(--success);">$14.9K MRR</div></div>
			<div class="detail-item"><div class="detail-item-label">🌴 Los Angeles, CA</div><div class="detail-item-value" style="color: var(--success);">$12.3K MRR</div></div>
			<div class="detail-item"><div class="detail-item-label">🌊 Miami, FL</div><div class="detail-item-value" style="color: var(--success);">$9.8K MRR</div></div>
		`;
	}
	
	if (growingMarkets) {
		growingMarkets.innerHTML = `
			<div class="detail-item"><div class="detail-item-label">🤠 Austin, TX</div><div class="detail-item-value" style="color: var(--primary);">+127% YoY</div></div>
			<div class="detail-item"><div class="detail-item-label">🎸 Nashville, TN</div><div class="detail-item-value" style="color: var(--primary);">+94% YoY</div></div>
			<div class="detail-item"><div class="detail-item-label">🏔️ Denver, CO</div><div class="detail-item-value" style="color: var(--primary);">+87% YoY</div></div>
			<div class="detail-item"><div class="detail-item-label">🌵 Phoenix, AZ</div><div class="detail-item-value" style="color: var(--primary);">+76% YoY</div></div>
		`;
	}
	
	if (marketsTable) {
		const markets = generateMarketsData();
		marketsTable.innerHTML = markets.map(m => `
			<tr>
				<td><strong>${m.city}</strong></td>
				<td>${m.region}</td>
				<td>${m.businesses}</td>
				<td><strong style="color: var(--success);">$${m.mrr}</strong></td>
				<td><span style="color: ${m.growth > 0 ? 'var(--success)' : 'var(--danger)'};">${m.growth > 0 ? '+' : ''}${m.growth}%</span></td>
				<td><span class="status-badge status-active">${m.status}</span></td>
			</tr>
		`).join('');
	}
}

function populateUsersSection() {
	const tbody = document.getElementById('usersTableBody');
	if (!tbody) return;
	
	const users = generateUsersData();
	tbody.innerHTML = users.map(user => `
		<tr>
			<td>
				<div style="display: flex; align-items: center; gap: 10px;">
					<div style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--purple)); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 12px;">
						${user.name.split(' ').map(n => n[0]).join('')}
					</div>
					<strong>${user.name}</strong>
				</div>
			</td>
			<td>${user.email}</td>
			<td><span class="badge badge-${user.roleClass}">${user.role}</span></td>
			<td>${user.business}</td>
			<td>${user.lastActive}</td>
			<td><span class="status-badge status-${user.status}">${user.status}</span></td>
			<td>
				<button class="action-btn" style="padding: 6px 12px; font-size: 11px;" onclick="editUser(${user.id})">Edit</button>
			</td>
		</tr>
	`).join('');
}

function populateTemplatesSection() {
	const grid = document.getElementById('templatesGrid');
	if (!grid) return;
	
	const templates = [
		{ icon: '🍽️', name: 'Restaurant', count: 142, color: '--primary' },
		{ icon: '💈', name: 'Salon & Spa', count: 48, color: '--pink' },
		{ icon: '🏥', name: 'Medical Office', count: 32, color: '--success' },
		{ icon: '🚗', name: 'Auto Service', count: 18, color: '--warning' },
		{ icon: '🐕', name: 'Pet Services', count: 7, color: '--purple' },
		{ icon: '🎯', name: 'Entertainment', count: 0, color: '--info' },
		{ icon: '🏋️', name: 'Fitness', count: 0, color: '--cyan' },
		{ icon: '📸', name: 'Photography', count: 0, color: '--danger' }
	];
	
	grid.innerHTML = templates.map(t => `
		<div class="template-item" style="cursor: pointer;" onclick="showTemplateDetails('${t.name}')">
			<div class="template-header">
				<div class="template-name">${t.icon} ${t.name}</div>
				<div class="template-count" style="color: var(${t.color});">${t.count}</div>
			</div>
			<div class="usage-bar">
				<div class="usage-fill" style="width: ${Math.min(t.count / 1.5, 100)}%; background: var(${t.color});"></div>
			</div>
			<div class="usage-stats">
				<span>${t.count} businesses using</span>
				<span>${t.count > 0 ? 'Active' : 'Available'}</span>
			</div>
		</div>
	`).join('');
}

function populateMarketingSection() {
	const tbody = document.getElementById('campaignsTableBody');
	if (!tbody) return;
	
	const campaigns = generateCampaignsData();
	tbody.innerHTML = campaigns.map(c => `
		<tr>
			<td><strong>${c.name}</strong></td>
			<td>${c.type}</td>
			<td>${c.audience}</td>
			<td>${c.sent}</td>
			<td>${c.opens} (${c.openRate}%)</td>
			<td>${c.clicks} (${c.clickRate}%)</td>
			<td><span class="status-badge status-${c.status}">${c.statusLabel}</span></td>
		</tr>
	`).join('');
}

function populateSupportSection() {
	const tbody = document.getElementById('ticketsTableBody');
	if (!tbody) return;
	
	const tickets = generateTicketsData();
	tbody.innerHTML = tickets.map(t => `
		<tr>
			<td><strong>#${t.id}</strong></td>
			<td>${t.subject}</td>
			<td>${t.business}</td>
			<td><span class="badge badge-${t.priorityClass}">${t.priority}</span></td>
			<td>${t.created}</td>
			<td><span class="status-badge status-${t.status}">${t.statusLabel}</span></td>
			<td>
				<button class="action-btn" style="padding: 6px 12px; font-size: 11px;" onclick="viewTicket(${t.id})">View</button>
			</td>
		</tr>
	`).join('');
}

function populateIntegrationsSection() {
	const grid = document.getElementById('integrationsGrid');
	if (!grid) return;
	
	const integrations = [
		{ 
			icon: '💳', 
			name: 'Stripe', 
			desc: 'Payment processing', 
			status: 'connected', 
			statusLabel: 'Connected',
			oauthUrl: 'https://connect.stripe.com/oauth/authorize',
			clientId: 'ca_xxxxxxxxxxxxx',
			scopes: 'read_write',
			apiDocs: 'https://stripe.com/docs/api'
		},
		{ 
			icon: '📱', 
			name: 'Twilio', 
			desc: 'SMS notifications', 
			status: 'connected', 
			statusLabel: 'Connected',
			oauthUrl: 'https://www.twilio.com/authorize',
			clientId: 'ACxxxxxxxxxxxxx',
			scopes: 'messages:write',
			apiDocs: 'https://www.twilio.com/docs/usage/api'
		},
		{ 
			icon: '📧', 
			name: 'SendGrid', 
			desc: 'Email delivery', 
			status: 'connected', 
			statusLabel: 'Connected',
			oauthUrl: 'https://api.sendgrid.com/v3/oauth/authorize',
			clientId: 'SG.xxxxxxxxxxxxx',
			scopes: 'mail.send',
			apiDocs: 'https://docs.sendgrid.com/api-reference'
		},
		{ 
			icon: '📊', 
			name: 'Google Analytics', 
			desc: 'Website analytics', 
			status: 'connected', 
			statusLabel: 'Connected',
			oauthUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
			clientId: 'xxxxxxxxxxxxx.apps.googleusercontent.com',
			scopes: 'https://www.googleapis.com/auth/analytics.readonly',
			apiDocs: 'https://developers.google.com/analytics/devguides/reporting/core/v4'
		},
		{ 
			icon: '🗓️', 
			name: 'Google Calendar', 
			desc: 'Calendar sync', 
			status: 'available', 
			statusLabel: 'Connect',
			oauthUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
			clientId: 'xxxxxxxxxxxxx.apps.googleusercontent.com',
			scopes: 'https://www.googleapis.com/auth/calendar',
			apiDocs: 'https://developers.google.com/calendar/api'
		},
		{ 
			icon: '💼', 
			name: 'QuickBooks', 
			desc: 'Accounting sync', 
			status: 'available', 
			statusLabel: 'Connect',
			oauthUrl: 'https://appcenter.intuit.com/connect/oauth2',
			clientId: 'ABxxxxxxxxxxxxx',
			scopes: 'com.intuit.quickbooks.accounting',
			apiDocs: 'https://developer.intuit.com/app/developer/qbo/docs/api/accounting/most-commonly-used/account'
		},
		{ 
			icon: '🔔', 
			name: 'Slack', 
			desc: 'Team notifications', 
			status: 'connected', 
			statusLabel: 'Connected',
			oauthUrl: 'https://slack.com/oauth/v2/authorize',
			clientId: 'xxxxxxxxxxxxx.xxxxxxxxxxxxx',
			scopes: 'chat:write,channels:read',
			apiDocs: 'https://api.slack.com/methods'
		},
		{ 
			icon: '📍', 
			name: 'Google Maps', 
			desc: 'Location services', 
			status: 'connected', 
			statusLabel: 'Connected',
			oauthUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
			clientId: 'xxxxxxxxxxxxx.apps.googleusercontent.com',
			scopes: 'https://www.googleapis.com/auth/maps',
			apiDocs: 'https://developers.google.com/maps/documentation'
		},
		{ 
			icon: '🌐', 
			name: 'Zapier', 
			desc: 'Workflow automation', 
			status: 'available', 
			statusLabel: 'Connect',
			oauthUrl: 'https://zapier.com/oauth/authorize',
			clientId: 'xxxxxxxxxxxxx',
			scopes: 'zap:write',
			apiDocs: 'https://platform.zapier.com/docs/integration'
		},
		{ 
			icon: '📱', 
			name: 'Facebook', 
			desc: 'Social booking', 
			status: 'available', 
			statusLabel: 'Connect',
			oauthUrl: 'https://www.facebook.com/v18.0/dialog/oauth',
			clientId: 'xxxxxxxxxxxxx',
			scopes: 'pages_manage_metadata,pages_read_engagement',
			apiDocs: 'https://developers.facebook.com/docs/graph-api'
		},
		{ 
			icon: '📷', 
			name: 'Instagram', 
			desc: 'Social media', 
			status: 'available', 
			statusLabel: 'Connect',
			oauthUrl: 'https://api.instagram.com/oauth/authorize',
			clientId: 'xxxxxxxxxxxxx',
			scopes: 'user_profile,user_media',
			apiDocs: 'https://developers.facebook.com/docs/instagram-api'
		},
		{ 
			icon: '🤖', 
			name: 'OpenAI', 
			desc: 'AI features', 
			status: 'connected', 
			statusLabel: 'Connected',
			oauthUrl: 'https://platform.openai.com/oauth/authorize',
			clientId: 'org-xxxxxxxxxxxxx',
			scopes: 'model.read,model.request',
			apiDocs: 'https://platform.openai.com/docs/api-reference'
		}
	];
	
	// Store integrations globally for modal access
	window.integrationsData = integrations;
	
	grid.innerHTML = integrations.map((i, index) => `
		<div class="integration-card" onclick="showIntegrationModal(${index})">
			<div class="integration-icon">${i.icon}</div>
			<div class="integration-info">
				<div class="integration-name">${i.name}</div>
				<div class="integration-status">${i.desc}</div>
			</div>
			<div class="integration-badge ${i.status}">${i.statusLabel}</div>
		</div>
	`).join('');
}

function showIntegrationModal(index) {
	const i = window.integrationsData[index];
	const modal = document.getElementById('modalContainer');
	
	modal.innerHTML = `
		<div class="modal-overlay" onclick="closeModal()">
			<div class="modal-content" onclick="event.stopPropagation()" style="max-width: 700px;">
				<div class="modal-header">
					<div class="modal-title">${i.icon} ${i.name} Integration</div>
					<button class="modal-close" onclick="closeModal()">×</button>
				</div>
				
				<div class="modal-stats-grid" style="grid-template-columns: repeat(2, 1fr);">
					<div class="modal-stat-card">
						<div class="modal-stat-value" style="font-size: 18px; color: ${i.status === 'connected' ? 'var(--success)' : 'var(--warning)'};">
							${i.status === 'connected' ? '✅ Connected' : '⚡ Available'}
						</div>
						<div class="modal-stat-label">Status</div>
					</div>
					<div class="modal-stat-card">
						<div class="modal-stat-value" style="font-size: 18px;">${i.desc}</div>
						<div class="modal-stat-label">Service Type</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">🔐 OAuth Configuration</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label">OAuth URL</div>
							<div class="detail-item-value" style="font-family: monospace; font-size: 11px; word-break: break-all;">${i.oauthUrl}</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">Client ID</div>
							<div class="detail-item-value" style="font-family: monospace; font-size: 12px;">${i.clientId}</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">Scopes</div>
							<div class="detail-item-value" style="font-family: monospace; font-size: 11px;">${i.scopes}</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label">Callback URL</div>
							<div class="detail-item-value" style="font-family: monospace; font-size: 11px;">https://api.dealsby.io/oauth/callback/${i.name.toLowerCase().replace(' ', '-')}</div>
						</div>
					</div>
				</div>
				
				<div class="modal-section">
					<div class="modal-section-title">📚 Resources</div>
					<div style="display: flex; gap: 12px; flex-wrap: wrap;">
						<a href="${i.apiDocs}" target="_blank" class="action-btn" style="text-decoration: none;">
							<span>📖</span> API Documentation
						</a>
						<button class="action-btn" onclick="copyOAuthUrl('${i.oauthUrl}')">
							<span>📋</span> Copy OAuth URL
						</button>
						${i.status === 'connected' ? `
							<button class="action-btn" style="background: var(--danger); border-color: var(--danger);" onclick="disconnectIntegration('${i.name}')">
								<span>🔌</span> Disconnect
							</button>
						` : `
							<button class="action-btn" style="background: var(--success); border-color: var(--success);" onclick="connectIntegration('${i.name}', '${i.oauthUrl}')">
								<span>🔗</span> Connect Now
							</button>
						`}
					</div>
				</div>
				
				${i.status === 'connected' ? `
				<div class="modal-section">
					<div class="modal-section-title">📊 Usage Statistics (30 days)</div>
					<div class="modal-stats-grid" style="grid-template-columns: repeat(3, 1fr);">
						<div class="modal-stat-card">
							<div class="modal-stat-value">${Math.floor(Math.random() * 50000) + 10000}</div>
							<div class="modal-stat-label">API Calls</div>
						</div>
						<div class="modal-stat-card">
							<div class="modal-stat-value">99.${Math.floor(Math.random() * 9) + 1}%</div>
							<div class="modal-stat-label">Success Rate</div>
						</div>
						<div class="modal-stat-card">
							<div class="modal-stat-value">${Math.floor(Math.random() * 200) + 50}ms</div>
							<div class="modal-stat-label">Avg Latency</div>
						</div>
					</div>
				</div>
				` : ''}
			</div>
		</div>
	`;
}

function copyOAuthUrl(url) {
	navigator.clipboard.writeText(url).then(() => {
		showToast('OAuth URL copied to clipboard!', 'success');
	});
}

function connectIntegration(name, oauthUrl) {
	showToast(`Initiating OAuth flow for ${name}...`, 'info');
	// In production, this would redirect to the OAuth URL with proper parameters
	setTimeout(() => {
		showToast(`${name} connected successfully!`, 'success');
		closeModal();
		populateIntegrationsSection();
	}, 1500);
}

function disconnectIntegration(name) {
	if (confirm(`Are you sure you want to disconnect ${name}?`)) {
		showToast(`Disconnecting ${name}...`, 'warning');
		setTimeout(() => {
			showToast(`${name} disconnected`, 'info');
			closeModal();
		}, 1000);
	}
}

// ==================== BRANDING & SETTINGS FUNCTIONS ====================

function copyColor(hex) {
	navigator.clipboard.writeText(hex).then(() => {
		showToast(`Color ${hex} copied to clipboard!`, 'success');
	}).catch(() => {
		showToast(`Color: ${hex}`, 'info');
	});
}

function editPlatformName() {
	const modal = document.getElementById('modalContainer');
	modal.innerHTML = `
		<div class="modal-overlay" onclick="closeModal()">
			<div class="modal-content" onclick="event.stopPropagation()" style="max-width: 500px;">
				<div class="modal-header">
					<div class="modal-title">✏️ Edit Platform Name</div>
					<button class="modal-close" onclick="closeModal()">×</button>
				</div>
				<div class="modal-section">
					<div style="margin-bottom: 20px;">
						<label style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px;">Platform Name</label>
						<input type="text" id="platformNameInput" value="Dealsby Reservations" class="search-input" style="width: 100%;" />
					</div>
					<div style="margin-bottom: 20px;">
						<label style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 8px;">Tagline</label>
						<input type="text" id="platformTaglineInput" value="Comprehensive Business Intelligence & Analytics Platform" class="search-input" style="width: 100%;" />
					</div>
					<div style="display: flex; gap: 12px; justify-content: flex-end;">
						<button class="action-btn" onclick="closeModal()">Cancel</button>
						<button class="action-btn" style="background: var(--success); border-color: var(--success);" onclick="savePlatformName()">Save Changes</button>
					</div>
				</div>
			</div>
		</div>
	`;
}

function savePlatformName() {
	const name = document.getElementById('platformNameInput').value;
	const tagline = document.getElementById('platformTaglineInput').value;
	showToast(`Platform name updated to "${name}"`, 'success');
	closeModal();
}

function uploadLogo() {
	const modal = document.getElementById('modalContainer');
	modal.innerHTML = `
		<div class="modal-overlay" onclick="closeModal()">
			<div class="modal-content" onclick="event.stopPropagation()" style="max-width: 500px;">
				<div class="modal-header">
					<div class="modal-title">🖼️ Upload Logo</div>
					<button class="modal-close" onclick="closeModal()">×</button>
				</div>
				<div class="modal-section">
					<div style="border: 2px dashed var(--border-color); border-radius: 12px; padding: 40px; text-align: center; cursor: pointer; transition: all 0.2s;" 
						 onclick="document.getElementById('logoFileInput').click()"
						 onmouseover="this.style.borderColor='var(--primary)'"
						 onmouseout="this.style.borderColor='var(--border-color)'">
						<div style="font-size: 48px; margin-bottom: 16px;">📁</div>
						<div style="font-size: 14px; color: var(--text-primary); margin-bottom: 8px;">Click to upload or drag and drop</div>
						<div style="font-size: 12px; color: var(--text-tertiary);">SVG, PNG, or JPG (max 2MB)</div>
						<input type="file" id="logoFileInput" accept=".svg,.png,.jpg,.jpeg" style="display: none;" onchange="handleLogoUpload(this)" />
					</div>
					<div style="margin-top: 20px;">
						<div style="font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 12px;">Current Logo</div>
						<div style="display: flex; align-items: center; gap: 16px; padding: 16px; background: rgba(255,255,255,0.03); border-radius: 8px;">
							<div style="font-size: 48px;">🍽️</div>
							<div>
								<div style="font-size: 14px; font-weight: 600; color: var(--text-primary);">Default Emoji Logo</div>
								<div style="font-size: 12px; color: var(--text-tertiary);">Using default branding</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	`;
}

function handleLogoUpload(input) {
	if (input.files && input.files[0]) {
		const file = input.files[0];
		showToast(`Uploading ${file.name}...`, 'info');
		setTimeout(() => {
			showToast('Logo uploaded successfully!', 'success');
			closeModal();
		}, 1500);
	}
}

function exportAllData() {
	showToast('Preparing data export...', 'info');
	setTimeout(() => {
		showToast('Data export ready! Download starting...', 'success');
	}, 2000);
}

function viewAPIDocs() {
	const modal = document.getElementById('modalContainer');
	modal.innerHTML = `
		<div class="modal-overlay" onclick="closeModal()">
			<div class="modal-content" onclick="event.stopPropagation()" style="max-width: 800px;">
				<div class="modal-header">
					<div class="modal-title">📖 API Documentation</div>
					<button class="modal-close" onclick="closeModal()">×</button>
				</div>
				<div class="modal-section">
					<div class="modal-section-title">🔑 Authentication</div>
					<div style="background: rgba(0,0,0,0.3); padding: 16px; border-radius: 8px; font-family: monospace; font-size: 12px; overflow-x: auto;">
						<div style="color: var(--text-tertiary);">// Include API key in headers</div>
						<div style="color: var(--success);">Authorization: Bearer YOUR_API_KEY</div>
						<div style="color: var(--text-tertiary);">Content-Type: application/json</div>
					</div>
				</div>
				<div class="modal-section">
					<div class="modal-section-title">🌐 Base URL</div>
					<div style="background: rgba(0,0,0,0.3); padding: 16px; border-radius: 8px; font-family: monospace; font-size: 13px;">
						https://api.dealsby.io/v1
					</div>
				</div>
				<div class="modal-section">
					<div class="modal-section-title">📋 Endpoints</div>
					<div class="detail-list">
						<div class="detail-item">
							<div class="detail-item-label" style="font-family: monospace;">GET /reservations</div>
							<div class="detail-item-value">List all reservations</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label" style="font-family: monospace;">POST /reservations</div>
							<div class="detail-item-value">Create new reservation</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label" style="font-family: monospace;">GET /businesses</div>
							<div class="detail-item-value">List all businesses</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label" style="font-family: monospace;">GET /customers</div>
							<div class="detail-item-value">List all customers</div>
						</div>
						<div class="detail-item">
							<div class="detail-item-label" style="font-family: monospace;">GET /analytics</div>
							<div class="detail-item-value">Get analytics data</div>
						</div>
					</div>
				</div>
				<div style="display: flex; gap: 12px; margin-top: 20px;">
					<a href="https://docs.dealsby.io" target="_blank" class="action-btn" style="text-decoration: none;">
						<span>📚</span> Full Documentation
					</a>
					<a href="https://docs.dealsby.io/api-reference" target="_blank" class="action-btn" style="text-decoration: none;">
						<span>🔧</span> API Reference
					</a>
				</div>
			</div>
		</div>
	`;
}

// ==================== FINISHED INCOMPLETE FEATURES ====================

function filterCustomers(value) {
	showToast(`Filtering customers: "${value}"`, 'info');
	// In production, this would filter the customers table
}

function setReservationPeriod(period) {
	document.querySelectorAll('#section-reservations .chart-btn').forEach(btn => btn.classList.remove('active'));
	event.target.classList.add('active');
	showToast(`Showing ${period} reservation data`, 'info');
}

function populateSystemSection() {
	const serverList = document.getElementById('serverStatusList');
	const resourceList = document.getElementById('resourceUsageList');
	const incidentsTable = document.getElementById('incidentsTableBody');
	
	if (serverList) {
		serverList.innerHTML = `
			<div class="detail-item"><div class="detail-item-label">🖥️ API Server</div><div class="detail-item-value" style="color: var(--success);">✅ Operational</div></div>
			<div class="detail-item"><div class="detail-item-label">🗄️ Database</div><div class="detail-item-value" style="color: var(--success);">✅ Operational</div></div>
			<div class="detail-item"><div class="detail-item-label">📡 CDN</div><div class="detail-item-value" style="color: var(--success);">✅ Operational</div></div>
			<div class="detail-item"><div class="detail-item-label">📧 Email Service</div><div class="detail-item-value" style="color: var(--success);">✅ Operational</div></div>
			<div class="detail-item"><div class="detail-item-label">📱 SMS Gateway</div><div class="detail-item-value" style="color: var(--success);">✅ Operational</div></div>
		`;
	}
	
	if (resourceList) {
		resourceList.innerHTML = `
			<div class="detail-item"><div class="detail-item-label">🔲 CPU Usage</div><div class="detail-item-value">34%</div></div>
			<div class="detail-item"><div class="detail-item-label">💾 Memory Usage</div><div class="detail-item-value">62%</div></div>
			<div class="detail-item"><div class="detail-item-label">💿 Disk Usage</div><div class="detail-item-value">47%</div></div>
			<div class="detail-item"><div class="detail-item-label">🌐 Network I/O</div><div class="detail-item-value">1.2 GB/s</div></div>
		`;
	}
	
	if (incidentsTable) {
		const incidents = generateIncidentsData();
		incidentsTable.innerHTML = incidents.map(i => `
			<tr>
				<td><strong>#${i.id}</strong></td>
				<td>${i.type}</td>
				<td>${i.description}</td>
				<td>${i.duration}</td>
				<td><span class="badge badge-${i.impactClass}">${i.impact}</span></td>
				<td><span class="status-badge status-${i.status}">${i.statusLabel}</span></td>
				<td>${i.date}</td>
			</tr>
		`).join('');
	}
}

function populateLogsSection() {
	const tbody = document.getElementById('logsTableBody');
	if (!tbody) return;
	
	const logs = generateLogsData();
	tbody.innerHTML = logs.map(log => `
		<tr>
			<td style="font-family: monospace; font-size: 12px;">${log.timestamp}</td>
			<td>${log.event}</td>
			<td>${log.user}</td>
			<td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis;">${log.details}</td>
			<td style="font-family: monospace; font-size: 11px;">${log.ip}</td>
			<td><span class="badge badge-${log.typeClass}">${log.type}</span></td>
		</tr>
	`).join('');
}

// ==================== DATA GENERATORS ====================

function generateReservationsData() {
	const statuses = ['active', 'confirmed', 'completed', 'cancelled'];
	const sources = ['Website', 'Mobile App', 'Phone', 'Walk-in', 'Google'];
	const businesses = dashboardState.businesses.slice(0, 10);
	const names = ['John Smith', 'Sarah Johnson', 'Mike Davis', 'Emily Brown', 'Chris Wilson', 'Jessica Lee', 'David Martinez', 'Amanda Taylor'];
	
	return Array.from({ length: 20 }, (_, i) => ({
		id: 100000 + i,
		business: businesses[i % businesses.length]?.name || 'Business',
		customer: names[i % names.length],
		dateTime: `Nov ${15 + Math.floor(i / 3)}, 2024 ${6 + (i % 8)}:${i % 2 === 0 ? '00' : '30'} PM`,
		partySize: 2 + (i % 6),
		status: statuses[i % statuses.length],
		source: sources[i % sources.length]
	}));
}

function generateCustomersData() {
	const names = ['Jennifer Adams', 'Robert Chen', 'Maria Garcia', 'James Wilson', 'Lisa Thompson', 'Daniel Kim', 'Ashley Rodriguez', 'Matthew Brown', 'Samantha Lee', 'Kevin Johnson'];
	const businesses = dashboardState.businesses.slice(0, 5);
	
	return names.map((name, i) => ({
		name,
		email: name.toLowerCase().replace(' ', '.') + '@email.com',
		phone: `(${212 + i}) 555-${1000 + i * 111}`,
		visits: 5 + (i * 3),
		lastVisit: `Nov ${10 + i}, 2024`,
		favorite: businesses[i % businesses.length]?.name || 'Various',
		status: i < 7 ? 'active' : 'inactive'
	}));
}

function generateTransactionsData() {
	const businesses = dashboardState.businesses.slice(0, 10);
	const types = ['Subscription', 'Subscription', 'Subscription', 'Upgrade', 'Add-on'];
	const methods = ['Credit Card', 'Credit Card', 'ACH', 'Credit Card', 'PayPal'];
	
	return Array.from({ length: 15 }, (_, i) => ({
		id: 'TXN-' + (90000 + i),
		business: businesses[i % businesses.length]?.name || 'Business',
		amount: [99, 199, 299, 499, 50][i % 5],
		type: types[i % types.length],
		status: i < 12 ? 'active' : 'trial',
		statusLabel: i < 12 ? 'Completed' : 'Pending',
		date: `Nov ${20 - i}, 2024`,
		method: methods[i % methods.length]
	}));
}

function generateReportsData() {
	return [
		{ id: 'R001', name: 'Monthly Revenue Summary', type: 'Revenue', range: 'Nov 1-30, 2024', generated: '2 hours ago', size: '2.4 MB' },
		{ id: 'R002', name: 'Business Performance Q4', type: 'Analytics', range: 'Oct 1 - Nov 30, 2024', generated: '1 day ago', size: '5.1 MB' },
		{ id: 'R003', name: 'Customer Growth Analysis', type: 'Customers', range: 'Last 90 days', generated: '3 days ago', size: '1.8 MB' },
		{ id: 'R004', name: 'Reservation Trends', type: 'Reservations', range: 'Nov 2024', generated: '5 days ago', size: '3.2 MB' },
		{ id: 'R005', name: 'Churn Analysis', type: 'Retention', range: 'Last 6 months', generated: '1 week ago', size: '4.7 MB' }
	];
}

function generateMarketsData() {
	return [
		{ city: '🗽 New York, NY', region: 'Northeast', businesses: 42, mrr: '18,400', growth: 23, status: 'Growing' },
		{ city: '🌉 San Francisco, CA', region: 'West Coast', businesses: 28, mrr: '14,892', growth: 31, status: 'Growing' },
		{ city: '🌴 Los Angeles, CA', region: 'West Coast', businesses: 24, mrr: '12,300', growth: 18, status: 'Growing' },
		{ city: '🌊 Miami, FL', region: 'Southeast', businesses: 19, mrr: '9,800', growth: 87, status: 'Hot' },
		{ city: '🏛️ Chicago, IL', region: 'Midwest', businesses: 18, mrr: '8,200', growth: 12, status: 'Stable' },
		{ city: '🤠 Austin, TX', region: 'Southwest', businesses: 15, mrr: '7,100', growth: 127, status: 'Hot' },
		{ city: '🎰 Las Vegas, NV', region: 'West', businesses: 14, mrr: '6,800', growth: 45, status: 'Growing' },
		{ city: '☕ Seattle, WA', region: 'Pacific NW', businesses: 12, mrr: '5,900', growth: 34, status: 'Growing' }
	];
}

function generateUsersData() {
	return [
		{ id: 1, name: 'Virely Admin', email: 'admin@virely.com', role: 'Super Admin', roleClass: 'danger', business: 'Virely LLC', lastActive: 'Now', status: 'active' },
		{ id: 2, name: 'Sarah Johnson', email: 'sarah@company.com', role: 'Admin', roleClass: 'warning', business: 'Bella Italia', lastActive: '5 min ago', status: 'active' },
		{ id: 3, name: 'Mike Chen', email: 'mike@restaurant.com', role: 'Manager', roleClass: 'primary', business: 'Ocean Grill', lastActive: '1 hour ago', status: 'active' },
		{ id: 4, name: 'Emily Davis', email: 'emily@bistro.com', role: 'Staff', roleClass: 'info', business: 'The Bistro', lastActive: '3 hours ago', status: 'active' },
		{ id: 5, name: 'James Wilson', email: 'james@cafe.com', role: 'Manager', roleClass: 'primary', business: 'Sunrise Cafe', lastActive: '1 day ago', status: 'inactive' }
	];
}

function generateCampaignsData() {
	return [
		{ name: 'Black Friday Sale', type: 'Email', audience: 'All Businesses', sent: '12,400', opens: '4,092', openRate: 33, clicks: '892', clickRate: 7.2, status: 'active', statusLabel: 'Active' },
		{ name: 'New Feature Announcement', type: 'Email', audience: 'Pro Users', sent: '8,200', opens: '3,116', openRate: 38, clicks: '654', clickRate: 8.0, status: 'active', statusLabel: 'Active' },
		{ name: 'Holiday Prep Tips', type: 'Email', audience: 'Restaurants', sent: '5,100', opens: '1,734', openRate: 34, clicks: '312', clickRate: 6.1, status: 'trial', statusLabel: 'Scheduled' },
		{ name: 'Upgrade Reminder', type: 'Email', audience: 'Trial Users', sent: '2,300', opens: '782', openRate: 34, clicks: '156', clickRate: 6.8, status: 'active', statusLabel: 'Active' }
	];
}

function generateTicketsData() {
	return [
		{ id: 1042, subject: 'Cannot access floor plan editor', business: 'Bella Italia', priority: 'High', priorityClass: 'danger', created: '2 hours ago', status: 'active', statusLabel: 'Open' },
		{ id: 1041, subject: 'SMS notifications not sending', business: 'Ocean Grill', priority: 'Critical', priorityClass: 'danger', created: '4 hours ago', status: 'trial', statusLabel: 'In Progress' },
		{ id: 1040, subject: 'Billing question', business: 'The Bistro', priority: 'Low', priorityClass: 'info', created: '1 day ago', status: 'active', statusLabel: 'Open' },
		{ id: 1039, subject: 'Feature request: Dark mode', business: 'Sunrise Cafe', priority: 'Low', priorityClass: 'info', created: '2 days ago', status: 'trial', statusLabel: 'Pending' },
		{ id: 1038, subject: 'Integration help needed', business: 'Tokyo Ramen', priority: 'Medium', priorityClass: 'warning', created: '3 days ago', status: 'active', statusLabel: 'Open' }
	];
}

function generateIncidentsData() {
	return [
		{ id: 'INC-001', type: 'Performance', description: 'Elevated API latency in US-East region', duration: '12 min', impact: 'Minor', impactClass: 'warning', status: 'active', statusLabel: 'Resolved', date: 'Nov 10, 2024' },
		{ id: 'INC-002', type: 'Outage', description: 'SMS gateway temporary unavailable', duration: '28 min', impact: 'Major', impactClass: 'danger', status: 'active', statusLabel: 'Resolved', date: 'Nov 3, 2024' },
		{ id: 'INC-003', type: 'Maintenance', description: 'Scheduled database maintenance', duration: '45 min', impact: 'Planned', impactClass: 'info', status: 'active', statusLabel: 'Completed', date: 'Oct 28, 2024' }
	];
}

function generateLogsData() {
	const events = [
		{ event: '🔐 User Login', type: 'Security', typeClass: 'success' },
		{ event: '💳 Payment Processed', type: 'Billing', typeClass: 'primary' },
		{ event: '📅 Reservation Created', type: 'User', typeClass: 'info' },
		{ event: '⚙️ Settings Updated', type: 'System', typeClass: 'warning' },
		{ event: '🏢 Business Registered', type: 'User', typeClass: 'info' },
		{ event: '📧 Email Sent', type: 'System', typeClass: 'warning' }
	];
	const users = ['admin@virely.com', 'sarah@bella.com', 'mike@ocean.com', 'System', 'emily@bistro.com'];
	
	return Array.from({ length: 20 }, (_, i) => {
		const e = events[i % events.length];
		return {
			timestamp: `2024-11-${20 - Math.floor(i/3)} ${12 + (i % 12)}:${(i * 7) % 60}:${(i * 13) % 60}`,
			event: e.event,
			user: users[i % users.length],
			details: `Action performed successfully - ID: ${10000 + i}`,
			ip: `192.168.${1 + (i % 5)}.${100 + i}`,
			type: e.type,
			typeClass: e.typeClass
		};
	});
}

// ==================== HELPER FUNCTIONS ====================

function filterBusinessesSection(value) {
	const searchTerm = value.toLowerCase();
	const filtered = dashboardState.businesses.filter(b => 
		b.name.toLowerCase().includes(searchTerm) || 
		b.owner.toLowerCase().includes(searchTerm)
	);
	const tbody = document.getElementById('businessTableSection');
	if (tbody) {
		tbody.innerHTML = filtered.map(business => `
			<tr onclick="showBusinessDetailsModal(${business.id})" style="cursor: pointer;">
				<td>
					<div style="display: flex; align-items: center; gap: 10px;">
						<div style="width: 36px; height: 36px; border-radius: 8px; background: linear-gradient(135deg, var(--primary), var(--purple)); display: flex; align-items: center; justify-content: center; font-weight: 700;">
							${business.name.charAt(0)}
						</div>
						<strong>${business.name}</strong>
					</div>
				</td>
				<td>${business.owner}</td>
				<td><span class="badge badge-primary">${business.plan}</span></td>
				<td><span class="status-badge status-${business.status}">${business.status}</span></td>
				<td>${business.template}</td>
				<td><strong>${business.reservations}</strong></td>
				<td><strong style="color: var(--success);">$${business.revenue}</strong></td>
				<td>${business.joinDate}</td>
				<td>
					<button style="padding: 6px 12px; background: var(--primary); border: none; border-radius: 6px; color: white; cursor: pointer; font-size: 11px; font-weight: 600;" onclick="event.stopPropagation(); showBusinessDetailsModal(${business.id})">
						View
					</button>
				</td>
			</tr>
		`).join('');
	}
}

function filterByPlan(plan) {
	const filtered = plan === 'all' 
		? dashboardState.businesses 
		: dashboardState.businesses.filter(b => b.plan === plan);
	
	const tbody = document.getElementById('businessTableSection');
	if (tbody) {
		tbody.innerHTML = filtered.map(business => `
			<tr onclick="showBusinessDetailsModal(${business.id})" style="cursor: pointer;">
				<td>
					<div style="display: flex; align-items: center; gap: 10px;">
						<div style="width: 36px; height: 36px; border-radius: 8px; background: linear-gradient(135deg, var(--primary), var(--purple)); display: flex; align-items: center; justify-content: center; font-weight: 700;">
							${business.name.charAt(0)}
						</div>
						<strong>${business.name}</strong>
					</div>
				</td>
				<td>${business.owner}</td>
				<td><span class="badge badge-primary">${business.plan}</span></td>
				<td><span class="status-badge status-${business.status}">${business.status}</span></td>
				<td>${business.template}</td>
				<td><strong>${business.reservations}</strong></td>
				<td><strong style="color: var(--success);">$${business.revenue}</strong></td>
				<td>${business.joinDate}</td>
				<td>
					<button style="padding: 6px 12px; background: var(--primary); border: none; border-radius: 6px; color: white; cursor: pointer; font-size: 11px; font-weight: 600;" onclick="event.stopPropagation(); showBusinessDetailsModal(${business.id})">
						View
					</button>
				</td>
			</tr>
		`).join('');
	}
}

function generateReport(type) {
	showToast(`Generating ${type} report...`, 'info');
	setTimeout(() => {
		showToast(`${type.charAt(0).toUpperCase() + type.slice(1)} report generated successfully!`, 'success');
	}, 2000);
}

function downloadReport(id) {
	showToast(`Downloading report ${id}...`, 'info');
}

function showAddBusinessModal() {
	showToast('Add Business modal coming soon', 'info');
}

function exportBusinesses() {
	showToast('Exporting businesses to CSV...', 'info');
}

function bulkActions() {
	showToast('Bulk actions panel coming soon', 'info');
}

function showAddUserModal() {
	showToast('Add User modal coming soon', 'info');
}

function showInviteModal() {
	showToast('Invite modal coming soon', 'info');
}

function manageRoles() {
	showToast('Role management coming soon', 'info');
}

function editUser(id) {
	showToast(`Editing user ${id}...`, 'info');
}

function showTemplateDetails(name) {
	showToast(`Viewing ${name} template details...`, 'info');
}

function createCampaign() {
	showToast('Campaign creator coming soon', 'info');
}

function emailBuilder() {
	showToast('Email builder coming soon', 'info');
}

function audienceManager() {
	showToast('Audience manager coming soon', 'info');
}

function filterTickets(status) {
	showToast(`Filtering by ${status}...`, 'info');
}

function viewTicket(id) {
	showToast(`Opening ticket #${id}...`, 'info');
}

function manageIntegration(name) {
	showToast(`Managing ${name} integration...`, 'info');
}

function exportLogs() {
	showToast('Exporting activity logs...', 'info');
}

function filterLogs(period) {
	showToast(`Filtering logs: ${period}`, 'info');
}

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function(event) {
	const sidebar = document.getElementById('leftSidebar');
	const toggle = document.querySelector('.sidebar-toggle');
	
	if (window.innerWidth <= 1024 && sidebar.classList.contains('open')) {
		if (!sidebar.contains(event.target) && event.target !== toggle) {
			toggleSidebar();
		}
	}
});

</script>

<!-- Mobile Sidebar Toggle Button -->
<button class="sidebar-toggle" onclick="toggleSidebar()">☰</button>

</div><!-- End main-content -->
</div><!-- End app-layout -->

</body>
</html>
