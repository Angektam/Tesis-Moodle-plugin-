/**
 * Dashboard JavaScript for AI Assignment
 *
 * @module     mod_aiassignment/dashboard
 * @copyright  2024 AI Assignment
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * Initialize the grade distribution chart
 * @param {Object} gradeData - Grade distribution data
 */
function initGradeChart(gradeData) {
    const ctx = document.getElementById('gradeChart');
    
    if (!ctx) {
        return;
    }
    
    // Prepare data for Chart.js
    const labels = [];
    const data = [];
    const backgroundColors = [];
    
    // Define grade ranges and colors
    const ranges = [
        { label: '90-100%', min: 90, max: 100, color: 'rgba(40, 167, 69, 0.8)' },
        { label: '80-89%', min: 80, max: 89, color: 'rgba(23, 162, 184, 0.8)' },
        { label: '70-79%', min: 70, max: 79, color: 'rgba(255, 193, 7, 0.8)' },
        { label: '60-69%', min: 60, max: 69, color: 'rgba(255, 152, 0, 0.8)' },
        { label: '0-59%', min: 0, max: 59, color: 'rgba(220, 53, 69, 0.8)' }
    ];
    
    // Count submissions in each range
    ranges.forEach(range => {
        let count = 0;
        gradeData.forEach(item => {
            if (item.grade >= range.min && item.grade <= range.max) {
                count++;
            }
        });
        labels.push(range.label);
        data.push(count);
        backgroundColors.push(range.color);
    });
    
    // Create the chart
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Number of Submissions',
                data: data,
                backgroundColor: backgroundColors,
                borderColor: backgroundColors.map(color => color.replace('0.8', '1')),
                borderWidth: 2,
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                },
                title: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: {
                        size: 14,
                        weight: 'bold'
                    },
                    bodyFont: {
                        size: 13
                    },
                    cornerRadius: 8,
                    callbacks: {
                        label: function(context) {
                            return 'Submissions: ' + context.parsed.y;
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        font: {
                            size: 12
                        }
                    },
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)'
                    }
                },
                x: {
                    ticks: {
                        font: {
                            size: 12,
                            weight: 'bold'
                        }
                    },
                    grid: {
                        display: false
                    }
                }
            },
            animation: {
                duration: 1000,
                easing: 'easeInOutQuart'
            }
        }
    });
}

/**
 * Initialize dashboard animations and interactions
 */
document.addEventListener('DOMContentLoaded', function() {
    // Animate stat cards on load
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach((card, index) => {
        setTimeout(() => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'all 0.5s ease';
            
            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 50);
        }, index * 100);
    });
    
    // Add hover effects to table rows
    const tableRows = document.querySelectorAll('.submissions-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.01)';
            this.style.transition = 'transform 0.2s ease';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });
    
    // Animate performer items
    const performerItems = document.querySelectorAll('.performer-item');
    performerItems.forEach((item, index) => {
        setTimeout(() => {
            item.style.opacity = '0';
            item.style.transform = 'translateX(-20px)';
            item.style.transition = 'all 0.5s ease';
            
            setTimeout(() => {
                item.style.opacity = '1';
                item.style.transform = 'translateX(0)';
            }, 50);
        }, index * 150);
    });
    
    // Add click animation to buttons
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('click', function(e) {
            const ripple = document.createElement('span');
            ripple.style.position = 'absolute';
            ripple.style.borderRadius = '50%';
            ripple.style.background = 'rgba(255, 255, 255, 0.6)';
            ripple.style.width = '20px';
            ripple.style.height = '20px';
            ripple.style.animation = 'ripple 0.6s ease-out';
            
            const rect = this.getBoundingClientRect();
            ripple.style.left = (e.clientX - rect.left - 10) + 'px';
            ripple.style.top = (e.clientY - rect.top - 10) + 'px';
            
            this.style.position = 'relative';
            this.style.overflow = 'hidden';
            this.appendChild(ripple);
            
            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });
});

// Add ripple animation CSS
const style = document.createElement('style');
style.textContent = `
    @keyframes ripple {
        from {
            transform: scale(0);
            opacity: 1;
        }
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Export for AMD module
if (typeof define === 'function' && define.amd) {
    define([], function() {
        return {
            initGradeChart: initGradeChart
        };
    });
}
