// Transparency page - loads and displays verification data

document.addEventListener('DOMContentLoaded', async () => {
  const statusEl = document.getElementById('transparencyStatus');
  const fileListEl = document.getElementById('fileList');
  
  try {
    // Fetch manifest
    const response = await fetch('transparency/manifest.json');
    if (!response.ok) throw new Error('Manifest not found');
    
    const manifest = await response.json();
    
    // Update deployment info
    document.getElementById('gitCommit').innerHTML = `
      <code>${manifest.git.commit_short}</code>
      <a href="${manifest.verification.github_url}/commit/${manifest.git.commit}" target="_blank" title="View commit">↗</a>
    `;
    document.getElementById('gitBranch').textContent = manifest.git.branch;
    document.getElementById('buildTime').textContent = new Date(manifest.generated).toLocaleString();
    document.getElementById('githubLink').href = `${manifest.verification.github_url}/tree/${manifest.git.commit_short}`;
    document.getElementById('githubCommitLink').href = `${manifest.verification.github_url}/commit/${manifest.git.commit}`;
    document.getElementById('commitForClone').textContent = manifest.git.commit_short;
    
    // Check for GPG signature
    try {
      const sigResponse = await fetch('transparency/manifest.sig', { method: 'HEAD' });
      document.getElementById('gpgStatus').innerHTML = sigResponse.ok 
        ? '✅ <a href="transparency/manifest.sig">Yes</a>'
        : '❌ No';
    } catch {
      document.getElementById('gpgStatus').textContent = '❌ No';
    }
    
    // Update status
    statusEl.innerHTML = `
      <div class="status-verified">
        <span class="status-icon">✅</span>
        <div class="status-text">
          <strong>Transparency data available</strong>
          <span>Deployed from commit <code>${manifest.git.commit_short}</code> on ${new Date(manifest.generated).toLocaleDateString()}</span>
        </div>
      </div>
    `;
    
    // Render file list
    let fileHtml = '<div class="file-table">';
    fileHtml += '<div class="file-header"><span>File</span><span>SHA256 Hash</span><span>Size</span></div>';
    
    for (const file of manifest.files) {
      const sizeKB = (file.size / 1024).toFixed(1);
      fileHtml += `
        <div class="file-row">
          <span class="file-path">
            <code>${file.path}</code>
            <a href="${file.path}" target="_blank" title="View file">↗</a>
          </span>
          <span class="file-hash"><code title="${file.sha256}">${file.sha256.substring(0, 16)}...</code></span>
          <span class="file-size">${sizeKB} KB</span>
        </div>
      `;
    }
    
    fileHtml += '</div>';
    fileHtml += `<p class="file-count">${manifest.files.length} files tracked</p>`;
    fileListEl.innerHTML = fileHtml;
    
  } catch (error) {
    statusEl.innerHTML = `
      <div class="status-error">
        <span class="status-icon">⚠️</span>
        <div class="status-text">
          <strong>Transparency data unavailable</strong>
          <span>Run <code>./generate-manifest.sh</code> to generate</span>
        </div>
      </div>
    `;
    
    fileListEl.innerHTML = '<p>No manifest found. Verification data will be available after the next build.</p>';
  }
});
